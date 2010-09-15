class JobsController < ApplicationController
  # GET /jobs
  # GET /jobs.xml
  
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_category_name, 
		:auto_complete_for_course_name, :auto_complete_for_proglang_name]
  auto_complete_for :category, :name
  auto_complete_for :course, :name
  auto_complete_for :proglang, :name
  
  # Ensures that only logged-in users can create, edit, or delete jobs
  before_filter :login_required, :except => [ :index, :show, :list ]
  
  # Ensures that only the user who created a job -- and no other users -- can edit it 
  before_filter :correct_user_access, :only => [ :edit, :update, :destroy ]
  
  
  def index
	  @jobs = Job.find_jobs             # finds all
  	@departments = Department.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end
  
  def list
  	params[:search_terms] ||= {}
  	@jobs = Job.find_jobs(params[:search_terms][:query], {
  		                    :department => params[:search_terms][:department_select].to_i, 
  		                    :faculty => params[:search_terms][:faculty_select].to_i, 
  		                    :paid => params[:search_terms][:paid].to_i, 
  		                    :credit => params[:search_terms][:credit].to_i
                            })	
  	respond_to do |format|
  		format.html { render :action => :index }
  		format.xml { render :xml => @jobs }
  	end
		
  end
    
  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new
	
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.xml
  def create
	  params[:job][:user] = current_user
		
  	# Handles the text_field_with_auto_complete for categories, courses, and programming languages
  	params[:job][:category_names] = params[:category][:name] if params[:category]
  	params[:job][:course_names] = params[:course][:name] if params[:course]
  	params[:job][:proglang_names] = params[:proglang][:name] if params[:proglang]
	
  	params[:job][:active] = false
  	params[:job][:activation_code] = 0
	

	sponsor = Faculty.find(params[:faculty_sponsor].to_i)
	  @job = Job.new(params[:job])
	  @sponsorship = Sponsorship.create(:faculty => sponsor, :job_id => 0)
  	@job.sponsorships << @sponsorship

    respond_to do |format|
      if @job.save
        @job.sponsorships.each {|s| s.job_id = @job.id}
    		@job.activation_code = (@job.id * 10000000) + (rand(99999) + 100000) # Job ID appended to a random 6 digit number.
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
	  #params[:job][:sponsorships] = Sponsorship.new(:faculty => Faculty.find(:first, :conditions => [ "name = ?", params[:job][:faculties] ]), :job => nil)	
    @job = Job.find(params[:id])
    @faculty_names = Faculty.all.map {|f| f.name }
	
	  sponsorships = []
  	if @job.faculties.first
			if params[:faculty_name] != @job.faculties.first.id 
				@sponsorship = Sponsorship.new(:faculty => Faculty.find(params[:faculty_name]), :job => nil)
				params[:job][:sponsorships] = [@sponsorship]
			end
		end
	
  	# Handles the text_field_with_auto_complete for categories, courses, and programming languages
    # TODO: check if these are relevant anymore?
#  	params[:job][:category_names] = params[:category][:name] if category_names_valid
#  	params[:job][:course_names] = params[:course][:name] if course_names_valid
#  	params[:job][:proglang_names] = params[:proglang][:name] if proglang_names_valid
			
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
  

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
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
  
  def apply
    job = Job.find(params[:id])
    applic = Applic.new({:user => current_user, :job => job})
    
    respond_to do |format|
        if applic.save
            flash[:notice] = 'Applied for job successfully. Time to cross your fingers and wait for a reply!'
            format.html { redirect_to(:controller=>:dashboard) }
        else
            flash[:notice] = 'Unsuccessful attempt to apply for a job. No worries, the economy is terrible these days.
                              <br />On a serious note, please contact the site administrators if you get this message 
                              repeatedly. Something went wrong.' 
            format.html { redirect_to(:controller=>:dashboard) }
        end
    end
  end
  
  protected
  
	  # Populates the tag_list of the job.
	def populate_tag_list
		tags_string = ""
		tags_string << @job.category_list_of_job 
		tags_string << ',' + @job.course_list_of_job unless @job.course_list_of_job.empty?
		tags_string << ',' + @job.proglang_list_of_job unless @job.proglang_list_of_job.empty?
		tags_string << ',' + (@job.paid ? 'paid' : 'unpaid')
		tags_string << ',' + (@job.credit ? 'credit' : 'no credit')
		@job.tag_list = tags_string
        print "\n\n\n\nPROGZ: #{@job.proglang_list_of_job}\nCOURSEZ: #{@job.course_list_of_job}\nTAGZ: #{@job.tag_list.to_s}\n\n\n\n\n"
	end
  
  private
	
	def correct_user_access
		if (Job.find(params[:id]) == nil || current_user != Job.find(params[:id]).user)
			flash[:notice] = "Unauthorized access denied. Do not pass Go. Do not collect $200."
			redirect_to :controller => 'dashboard', :action => :index
		end
	end
end
