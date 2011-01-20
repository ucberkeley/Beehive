class JobsController < ApplicationController
  # GET /jobs
  # GET /jobs.xml
  
  include CASControllerIncludes
  
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_category_name, 
		:auto_complete_for_course_name, :auto_complete_for_proglang_name]
  auto_complete_for :category, :name
  auto_complete_for :course, :name
  auto_complete_for :proglang, :name
  
  #CalNet / CAS Authentication
  before_filter CASClient::Frameworks::Rails::Filter
  #before_filter :goto_cas_unless_logged_in
    
  # Ensures that only logged-in users can create, edit, or delete jobs
  before_filter :rm_login_required #, :except => [ :index, :show ]
  
  # Ensures that only the user who created a job -- and no other users -- can edit 
  # or destroy it.
  before_filter :check_post_permissions, :only => [ :new, :create ]
  before_filter :correct_user_access, :only => [ :edit, :update, :delete, :destroy ]

  protected
  def search_params_hash
    h = {}
    # booleans
    [:paid, :credit, :expired, :filled].each do |param|
      h[param] = params[param] if ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[param]) #unless params[param].nil?
    end
    
    # strings, directly copy attribs
    [:query, :tags, :page, :per_page, :as].each do |param|
      h[param] = params[param] unless params[param].blank?
    end

    # dept. 0 => all
    h[:department] = params[:department] if params[:department].to_i > 0
    h[:faculty]    = params[:faculty]    if params[:faculty].to_i    > 0

    h
  end

  public
  
  def index #list
    # strip out some weird args
    # may cause double-request but that's okay
    redirect_to(search_params_hash) and return if [:commit, :utf8].any? {|k| !params[k].nil?}

    # Tags will filter whatever the query returns

    @jobs = Job.find_jobs(params[:query], {
                                :department => params[:department].to_i, 
                                :faculty => params[:faculty].to_i, 
                                :paid => ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:paid]),
                                :credit => ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:credit]),

                                # will_paginate
                                :page => params[:page] || 1,
                                :per_page => params[:per_page]
                          })
    
    @department_id = params[:department] ? params[:department].to_i : 0
    @faculty_id    = params[:faculty]    ? params[:faculty].to_i    : 0
    @query         = ((not params[:query].nil?) and (not params[:query].empty?)) ? params[:query] : nil
    
    if params[:tags].present?
      jobs_tagged_with_tags = Job.find_tagged_with(params[:tags])
      @jobs = @jobs.select { |job| jobs_tagged_with_tags.include?(job) }
    end
  	
    respond_to do |format|
            format.html { render :action => :index }
            format.xml { render :xml => @jobs }
    end
  end
    
  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])

    # update watch time so this job is now 'read'
    if current_user.present? && (watch=Watch.find(:first, :conditions => {:user_id => current_user.id, :job_id => @job.id}))
        watch.mark_read
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new

    respond_to do |format|
      format.html { render :action => 'edit' }
      format.xml
    end
	
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
    @job.mend
    
    respond_to do |format|
        format.html
        format.xml
    end
    
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    params[:job][:user] = current_user
            
    process_form_params

    params[:job][:active] = false
    params[:job][:activation_code] = 0
    

    sponsor = Faculty.find(params[:faculty_sponsor].to_i)
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.valid_without_sponsorships?
        @sponsorship = Sponsorship.find_or_create_by_faculty_id_and_job_id(sponsor.id, @job.id)
        @job.sponsorships << @sponsorship
        @job.activation_code = ActiveSupport::SecureRandom.random_number(10e6.to_i)
        # don't have id at this point     #(@job.id * 10000000) + (rand(99999) + 100000) # Job ID appended to a random 6 digit number.
        @job.save
        flash[:notice] = 'Thank you for submitting a job.  Before this job can be added to our listings page and be viewed by '
        flash[:notice] << 'other users, it must be approved by the faculty sponsor.  An e-mail has been dispatched to the faculty '
        flash[:notice] << 'sponsor with instructions on how to activate this job.  Once activated, users will be able to browse and respond to the job posting.'
        
        #TODO: Send an e-mail to the faculty member(s) involved.
        # At this point, ActionMailer should have been set up by /config/environment.rb
        FacultyMailer.deliver_faculty_confirmer(sponsor.email, sponsor.name, @job)
        
        format.html { redirect_to(@job) }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update	
    process_form_params

    @job = Job.find(params[:id])
	
    update_sponsorships  	
			
    respond_to do |format|
      if @job.update_attributes(params[:job])
        
        populate_tag_list
        @job.save
        flash[:notice] = 'Job was successfully updated.'
        format.html { redirect_to(@job) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # Just the page that asks for confirmation for deletion of the job.
  # The actual deletion is performed by the "destroy" action.
  def delete
    @job = Job.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      flash[:notice] = "Listing deleted successfully."
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
  
  def activate
    # /jobs/activate/job_id?a=xxx
	  @job = Job.find(:first, :conditions => [ "activation_code = ? AND active = ?", params[:a], false ])
	
	  if @job != nil
  		populate_tag_list
		
  		@job.skip_handlers = true
  		@job.active = true
  		saved = @job.save
  	else 
  		saved = false
  	end
	
  	respond_to do |format|
  		if saved
  		  @job.skip_handlers = false
  		  flash[:notice] = 'Job activated successfully.  Your job is now available to be browsed and viewed by other users.'
  		  format.html { redirect_to(@job) }
  		else
  		  flash[:notice] = 'Unsuccessful activation.  Either this job has already been activated or the activation code is incorrect.'
  		  format.html { redirect_to(jobs_url) }
  		end
  	end
  end
  
  def job_read_more
	  job = Job.find(params[:id])
  	render :text=> job.desc
  end
  
  def job_read_less
	  job = Job.find(params[:id])
  	desc = job.desc.first(100)
  	desc = desc << "..." if job.desc.length > 100
  	render :text=>  desc
  end
  
  def watch	
	  job = Job.find(params[:id])
  	watch = Watch.new({:user=> current_user, :job => job})
	
  	respond_to do |format|
  		if watch.save
  		  flash[:notice] = 'Job is now watched. You can find a list of your watched jobs on the dashboard.'
  		  format.html { redirect_to(:controller=>:dashboard) }
  		else
  		  flash[:notice] = 'Unsuccessful job watch. Perhaps you\'re already watching this job?'
  		  format.html { redirect_to(:controller=>:dashboard) }
  		end
  	end
  end
  
 def unwatch	
   job = Job.find(params[:id])
   watch = Watch.find(:first, :conditions=>{:user_id=> current_user.id, :job_id => job.id})

   respond_to do |format|
  	 if watch.destroy
  	   flash[:notice] = 'Job is now unwatched. You can find a list of your watched jobs on the dashboard.'
  	   format.html { redirect_to(:controller=>:dashboard) }
  	 else
  	   flash[:notice] = 'Unsuccessful job un-watch. Perhaps you\'re not watching this job yet?'
  	   format.html { redirect_to(:controller=>:dashboard) }
  	 end
   end
	
  end
  
  
  
  protected
  # Preprocesses form data for direct input to Job.update
  def process_form_params
    # Handles the text_fields for categories, courses, and programming languages
    [:category, :course, :proglang].each do |k|
      params[:job]["#{k.to_s}_names".to_sym] = params[k][:name]
    end

    # Handle three-state booleans
    [:paid, :credit].each do |k|
      params[:job][k] = [false,true,nil][params[:job][k].to_i]
    end
  end


    # Saves sponsorship specified in the params page
    def update_sponsorships
        fac = Faculty.exists?(params[:faculty_name]) ? params[:faculty_name] : 0
        sponsor = Sponsorship.find(:first, :conditions => {:job_id=>@job.id, :faculty_id=>fac} ) || Sponsorship.create(:job_id=>@job.id, :faculty_id=>fac)
        @job.sponsorships = [sponsor]
    end
  
  
	  # Populates the tag_list of the job.
	def populate_tag_list
		tags_string = ""
        tags_string << @job.department.name
		tags_string << ',' + @job.category_list_of_job 
		tags_string << ',' + @job.course_list_of_job unless @job.course_list_of_job.empty?
		tags_string << ',' + @job.proglang_list_of_job unless @job.proglang_list_of_job.empty?
		tags_string << ',' + (@job.paid ? 'paid' : 'unpaid')
		tags_string << ',' + (@job.credit ? 'credit' : 'no credit')
		@job.tag_list = tags_string
	end
  
  private
  

	
	def correct_user_access
		if (Job.find(params[:id]) == nil || current_user != Job.find(params[:id]).user)
			flash[:error] = "Unauthorized access denied. Do not pass Go. Do not collect $200."
			redirect_to :controller => 'dashboard', :action => :index
		end
	end
	
	def check_post_permissions
	    if not current_user.can_post?
	        flash[:error] = "Sorry, you don't have permissions to post a new listing. Become a grad student or ask to be hired as faculty."
	        redirect_to :controller => 'dashboard', :action => :index
	    end
	end
	
end
