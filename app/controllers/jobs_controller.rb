class JobsController < ApplicationController
  # GET /jobs
  # GET /jobs.xml
  
  # Ensures that only logged-in users can create, edit, or delete jobs
  before_filter :login_required, :except => [ :index, :show, :list ]
  
  def index
    @jobs = Job.find(:all, :conditions => [ "active = ?", true ])
	@departments = Department.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end
  
  def list
	d_id = params[:department_select]
	
	params[:search_terms] ||= {}
	query = params[:search_terms][:query]
	if(query && !query.empty?)
		@jobs = Job.find_by_solr(query).results
	else
	end #end params[:query]

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
	params[:job][:activation_code] = (rand(99999) + 100000)*100000000000 + Time.now.to_i # Generates a random 7 digit number and appends the result the current UNIX time to that number.
	params[:job][:active] = false
	sponsorships = []
	@job = Job.new(params[:job])
	@sponsorship = Sponsorship.new(:faculty => Faculty.find(params[:faculty_name]), :job => @job)
	@job.sponsorships = sponsorships << @sponsorship
	
    respond_to do |format|
      if @job.save
		#@sponsorship.save
        flash[:notice] = 'Thank you for submitting a job.  Before this job can be added to our listings page and be viewed by other users, it must be approved by the faculty sponsor.  An e-mail has been dispatched to the faculty sponsor with instructions on how to activate this job.  Once activated, users will be able to browse and respond to the job posting.'
		
		# Send an e-mail to the faculty member(s) involved.
		
		#FacultyMailer.deliver_faculty_confirmer(found_faculty.email, found_faculty.name, params[:job][:title], params[:job][:desc], params[:job][:activation_code])
		
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
    # /jobs/activate?id=xxx
	@job = Job.find(:first, :conditions => [ "activation_code = ? AND active = ?", params[:id], false ])
	if @job
	  @job.active = true
	  @job.save
	  flash[:notice] = 'Job activated successfully.  Your job is now available to be browsed and viewed by other users.'
	  format.html { redirect_to(@job) }
	else
	  flash[:notice] = 'Unsuccessful activation.  Either this job has already been activated or the activation code is incorrect.'
	  format.html { redirect_to(jobs_url) }
	end
  end
end
