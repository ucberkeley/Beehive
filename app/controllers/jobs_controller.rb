class JobsController < ApplicationController

  #CalNet / CAS Authentication
  before_filter CASClient::Frameworks::Rails::Filter

  # GET /jobs
  # GET /jobs.xml
  def index
    @jobs = Job.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
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
      format.html # new.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.xml
  def create
  
    params[:job][:user] = current_user

    params[:job][:active] = false
    params[:job][:activation_code] = 0
    
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        @job.activation_code = ActiveSupport::SecureRandom.random_number(10e6.to_i)
        # don't have id at this point     #(@job.id * 10000000) + (rand(99999) + 100000) # Job ID appended to a random 6 digit number.
        @job.save
        logger.warn "\nJob " + @job.id.to_s + " successfully created; activation code : " + @job.activation_code.to_s + "\n"
        flash[:notice] = 'Thank you for submitting a job.  Before this job can be added to our listings page and be viewed by '
        flash[:notice] << 'other users, it must be approved by the faculty sponsor.  An e-mail has been dispatched to the faculty '
        flash[:notice] << 'sponsor with instructions on how to activate this job.  Once activated, users will be able to browse and respond to the job posting.'
        
        format.html { redirect_to(@job, :notice => 'Job was successfully created.') }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  
  end
  
  def activate
    # /jobs/id/activate?a=####
	  @job = Job.find(:first, :conditions => [ "activation_code = ? AND active = ?", params[:a], false ])
	
	  if @job != nil
  		@job.active = true
  		saved = @job.save
  	else 
  		saved = false
  	end
	
  	respond_to do |format|
  		if saved
  		  flash[:notice] = 'Job activated successfully.  Your job is now available to be browsed and viewed by other users.'
  		  format.html { redirect_to(@job) }
  		else
  		  flash[:notice] = 'Unsuccessful activation.  Either this job has already been activated or the activation code is incorrect.'
  		  format.html { redirect_to(jobs_url) }
  		end
  	end
  end  
  
  

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to(@job, :notice => 'Job was successfully updated.') }
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
