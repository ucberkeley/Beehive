class JobsController < ApplicationController
  # GET /jobs
  # GET /jobs.xml
  
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_category_name]
  auto_complete_for :category, :name
  
  # Ensures that only logged-in users can create, edit, or delete jobs
  before_filter :login_required, :except => [ :index, :show, :list ]
  
  def index
    @search_query = "keyword (leave blank to view all)"
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
	@search_query = "keyword (leave blank to view all)"
	d_id = params[:department_select]
	
	params[:search_terms] ||= {}
	query = params[:search_terms][:query]
	department = params[:search_terms][:department_select].to_i
	faculty = params[:search_terms][:faculty_select].to_i
	paid = params[:search_terms][:paid].to_i
	credit = params[:search_terms][:credit].to_i

	if(query && !query.empty? && (query != @search_query))
		@jobs = Job.find_by_solr(query).results.select { |c| c.active == true }.sort {|a,b| a.created_at <=> b.created_at} # How to filter these results pre-query through solr?  Should actually be filtered through solr, not here.
		
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
	#params[:job][:category_id] = Category.find_or_create_by_name(params[:category][:name].id)
	params[:job][:category_names] = params[:category][:name]
		# = Category.find_or_create_by_name(params[:category][:name])
	params[:job][:active] = false
	
	sponsorships = []
	params[:job][:activation_code] = 100
	if params[:faculty_name] != ""
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

	
	# Handles the text_field_with_auto_complete for categories.
	params[:job][:category_names] = params[:category][:name]
	
    @all_faculty = Faculty.find(:all)
    @faculty_names = []
    @all_faculty.each do |faculty|
      @faculty_names << faculty.name
    end
	
	populate_tag_list
	
    respond_to do |format|
      if @job.update_attributes(params[:job])
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
		
		@job.skip_handle_categories = true
		@job.active = true
		saved = @job.save
	else
		saved = false
	end
	
	respond_to do |format|
		if saved
		  @job.skip_handle_categories = false
		  flash[:notice] = 'Job activated successfully.  Your job is now available to be browsed and viewed by other users.'
		  format.html { redirect_to(@job) }
		else
		  flash[:notice] = 'Unsuccessful activation.  Either this job has already been activated or the activation code is incorrect.'
		  format.html { redirect_to(jobs_url) }
		end
	end
	
  end
  
  
  protected
  
  def populate_tag_list
  
	# Debug code
	puts "\n\n\n\n\n LAWL \n"
	puts @job.paid
	puts "\n done \n "
	
  
	# Populates the tag_list of the job.
	tags_string = ""
	tags_string << @job.category_list_of_job 
	tags_string << ',' + (@job.paid ? 'paid' : 'unpaid')
	tags_string << ',' + (@job.credit ? 'credit' : 'no credit')
	@job.tag_list = tags_string
  end
end