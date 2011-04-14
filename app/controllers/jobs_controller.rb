class JobsController < ApplicationController
  include AttribsHelper

  #CalNet / CAS Authentication
  #before_filter CASClient::Frameworks::Rails::Filter # done in rm_login_required
  before_filter :rm_login_required
  
  # Ensures that only the user who created a job -- and no other users -- can edit 
  # or destroy it.
  #####before_filter :check_post_permissions, :only => [ :new, :create ]
  before_filter :correct_user_access, :only => [ :edit, :update, :delete, :destroy ]
  
  # GET /jobs
  # GET /jobs.xml
  def index
    search_params = {}
    @jobs = Job.search params[:q], search_params

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])
    @logged_in = logged_in?
    prepare_attribs_in_params(@job)    
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
    prepare_attribs_in_params(@job)
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
        @job.update_attribs(params)
        @job.handle_sponsorships(params[:faculty_sponsor].to_i)        
        @job.save
        logger.warn "\nJob " + @job.id.to_s + " successfully created; activation code : " + @job.activation_code.to_s + "\n"
        flash[:notice] = 'Thank you for submitting a listing.  Before this listing can be added to our listings page and be viewed by '
        flash[:notice] << 'other users, it must be approved by the faculty sponsor.  An e-mail has been dispatched to the faculty '
        flash[:notice] << 'sponsor with instructions on how to activate this listing.  Once activated, users will be able to browse and respond to the posting.'
        
        format.html { redirect_to(@job) }
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
  		  flash[:notice] = 'Listing activated successfully.  Your listing is now available to be browsed and viewed by other users.'
  		  format.html { redirect_to(@job) }
  		else
  		  flash[:notice] = 'Unsuccessful activation.  Either this listing has already been activated or the activation code is incorrect.'
  		  format.html { redirect_to(jobs_url) }
  		end
  	end
  end  

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find(params[:id])
    #logger.warn params.inspect
    respond_to do |format|
      if @job.update_attributes(params[:job])
        @job.update_attribs(params)
        @job.handle_sponsorships(params[:faculty_sponsor].to_i)
        format.html { redirect_to(@job, :notice => 'Listing was successfully updated.') }
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
      format.html { redirect_to(jobs_url, :notice => 'Listing was deleted successfully.') }
      format.xml  { head :ok }
    end
  end

  def watch	
	  job = Job.find(params[:id])
  	watch = Watch.new({:user=> current_user, :job => job})
	
  	respond_to do |format|
  		if watch.save
  		  flash[:notice] = 'Listing is now watched. You can find a list of your watched listings on the dashboard.'
  		  format.html { redirect_to(:controller=>:dashboard) }
  		else
  		  flash[:notice] = 'Unsuccessful listing watch. Perhaps you\'re already watching this listing?'
  		  format.html { redirect_to(:controller=>:dashboard) }
  		end
  	end
  end
  
 def unwatch	
   job = Job.find(params[:id])
   watch = Watch.find(:first, :conditions=>{:user_id=> current_user.id, :job_id => job.id})

   respond_to do |format|
  	 if watch.destroy
  	   flash[:notice] = 'Listing is now unwatched. You can find a list of your watched listings on the dashboard.'
  	   format.html { redirect_to(:controller=>:dashboard) }
  	 else
  	   flash[:notice] = 'Unsuccessful listing un-watch. Perhaps you\'re not watching this listing yet?'
  	   format.html { redirect_to(:controller=>:dashboard) }
  	 end
   end
  end
  
  # PRIVATE methods below e.g. filter methods
  private
  
	def correct_user_access
		if (Job.find(params[:id]) == nil || current_user != Job.find(params[:id]).user)
      flash[:error] = "Unauthorized access denied. Do not pass Go. Do not collect $200."
      redirect_to jobs_path
      return false
		end
	end  

end
