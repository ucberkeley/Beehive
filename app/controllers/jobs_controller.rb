class JobsController < ApplicationController
  require "digest" # Used to generate codes for activation e-mails
  
  # GET /jobs
  # GET /jobs.xml
  
  # Ensures that only logged-in users can create, edit, or delete jobs
  before_filter :login_required, :except => [ :index, :show, :list ]
  
  def index
    @jobs = Job.all

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
	
	if(d_id == "0")
		@department = "All Departments"
		@jobs = Job.all
	else
		@department = Department.find(d_id).name
		@jobs = Job.all
	end
	
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

    respond_to do |format|
      format.html { render :action => :modify }
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
	
	respond_to do |format|
		format.html { render :action => :modify }
		format.xml { render :xml => @job }
	end
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    # This create does not actually create the job - an activation is necessary from the professor to actually create it.
	
	params[:job][:user] = current_user
	params[:job][:activation_code] = rand(99999) + 100000 # Generates a random 7 digit number.
    @job = JobInactive.new(params[:job])

    respond_to do |format|
      if @job.save
        flash[:notice] = 'Thanks for submitting your job.  An e-mail has been dispatched to the professor in charge and will require e-mail confirmation before this job is posted to our main page.'
		
		# Sends an e-mail to the appropriate faculty member in charge.
		
		# This doesn't actually send the e-mail yet, so you'll have to look in the database to find the activation code.
		
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
    @job = Job.find(params[:id])

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
end
