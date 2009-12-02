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
  
  def index
    @search_query = "Keyword (leave blank to view all)"
	#@search_query = params[:search_terms][:query]
	#@department = params[:search_terms][:department]
	#@faculty = params[:search_terms][:faculty]
	#@paid = params[:search_terms][:paid]
	#@credit = params[:search_terms][:credit]
	
	#@department ||= 0
	#@faculty ||= 0
	#@paid ||= 0
	#@credit ||= 0
	
    @jobs = Job.find(:all, :conditions => [ "active = ?", true ], :order => "created_at DESC")
	@departments = Department.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end
  
  def list
	@search_query = "Keyword (leave blank to view all)"
	d_id = params[:department_select]
	
	params[:search_terms] ||= {}
	query = params[:search_terms][:query]
	department = params[:search_terms][:department_select].to_i
	faculty = params[:search_terms][:faculty_select].to_i
	paid = params[:search_terms][:paid].to_i
	credit = params[:search_terms][:credit].to_i

	if(query && !query.empty? && (query != @search_query))
		@jobs = Job.find_by_solr_by_relevance(query).select { |c| c.active == true } # How to filter these results pre-query through solr?  Should actually be filtered through solr, not here.
		@jobs = @jobs.sort {|a,b| a.created_at <=> b.created_at} if false
		
	else
		#flash[:notice] = 'Your query was invalid and could not return any results.'
		@jobs = Job.find(:all, :order=>"created_at DESC", :conditions=> {:active => true})
	end #end params[:query]

	@jobs = @jobs.select {|j| j.department_id.to_i == department } if department != 0
	@jobs = @jobs.select {|j| j.faculties.collect{|f| f.id.to_i}.include?(faculty) }  if faculty != 0
	@jobs = @jobs.select {|j| j.paid } if paid != 0
	@jobs = @jobs.select {|j| j.credit } if credit != 0
	
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
	
    @all_faculty = Faculty.find(:all)
    @faculty_names = []
    @all_faculty.each do |faculty|
      @faculty_names << faculty.name
    end
	
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
	
    @all_faculty = Faculty.find(:all)
    @faculty_names = []
    @all_faculty.each do |faculty|
      @faculty_names << faculty.name
    end

  end

  # POST /jobs
  # POST /jobs.xml
  def create
	params[:job][:user] = current_user
	
	category_names_valid = false
	course_names_valid = false
	proglang_names_valid = false
	if params[:category]
		category_names_valid = true if params[:category][:name]
	end
	if params[:category]
		course_names_valid = true if params[:course][:name]
	end
	if params[:category]
		proglang_names_valid = true if params[:proglang][:name]
	end
		
	# Handles the text_field_with_auto_complete for categories.
	params[:job][:category_names] = params[:category][:name] if category_names_valid
	
	# Handles the text_field_with_auto_complete for required courses.
	params[:job][:course_names] = params[:course][:name] if course_names_valid
	
	# Handles the text_field_with_auto_complete for desired proglangs.
	params[:job][:proglang_names] = params[:proglang][:name] if proglang_names_valid
	
	
	params[:job][:active] = false
	
	
	params[:job][:activation_code] = 100
	
	sponsorships = []
	if params[:faculty_name] != "" && params[:faculty_name]
		@sponsorship = Sponsorship.new(:faculty => Faculty.find(params[:faculty_name]), :job => nil)
		params[:job][:sponsorships] = sponsorships << @sponsorship
	end
	@job = Job.new(params[:job])
	
    respond_to do |format|
      if @job.save
		#@sponsorship.save
		@job.sponsorships.each { |c| c.job = @job }
		@job.activation_code = (@job.id * 10000000) + (rand(99999) + 100000) # Job ID appended to a random 6 digit number.
		@job.save
        flash[:notice] = 'Thank you for submitting a job.  Before this job can be added to our listings page and be viewed by '
		flash[:notice] << 'other users, it must be approved by the faculty sponsor.  An e-mail has been dispatched to the faculty '
		flash[:notice] << 'sponsor with instructions on how to activate this job.  Once activated, users will be able to browse and respond to the job posting.'
		
		# Send an e-mail to the faculty member(s) involved.
		
		#FacultyMailer.deliver_faculty_confirmer(found_faculty.email, found_faculty.name, @job.id, @job.title, @job.desc, @job.activation_code)
		
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
	
    @all_faculty = Faculty.find(:all)
    @faculty_names = []
    @all_faculty.each do |faculty|
      @faculty_names << faculty.name
    end
	
	sponsorships = []
	if @job.faculties
		if @job.faculties.first
			if params[:faculty_name] != @job.faculties.first.id 
				@sponsorship = Sponsorship.new(:faculty => Faculty.find(params[:faculty_name]), :job => nil)
				params[:job][:sponsorships] = sponsorships << @sponsorship
			end
		end
	end
	
	
	# Handles the text_field_with_auto_complete for categories.
	params[:job][:category_names] = params[:category][:name]
	
	# Handles the text_field_with_auto_complete for required courses.
	params[:job][:course_names] = params[:course][:name]
	
	# Handles the text_field_with_auto_complete for desired proglangs.
	params[:job][:proglang_names] = params[:proglang][:name]
			
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
  end
  
  
end