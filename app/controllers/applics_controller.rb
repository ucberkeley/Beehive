class ApplicsController < ApplicationController
  include CASControllerIncludes
  before_filter :rm_login_required

  before_filter :find_objects

  # These filters verify that current_user has the right permissions
  before_filter :verify_applic_ownership, :only => [:destroy]  # only applicant can withdraw
  before_filter :verify_applic_admin,     :only => [:show, :resume, :transcript]     # applicant, job admin can view applic
  before_filter :verify_job_ownership,    :only => [:index]    # only job admin can view applics
  before_filter :verify_job_unapplied,    :only => [:new, :create] # don't allow multiple applications


  protected
  def find_objects
    @applic = Applic.find(params[:id])  unless params[:id].blank?
    @job    = Job.find(params[:job_id]) unless params[:job_id].blank?
  end

  def verify_job_unapplied
    if existing = Applic.find(:first, :conditions => {:user_id => current_user.id, :job_id => @job.id})
       flash[:error] = "Whoa, slow down! You've already applied for this job. If you'd like to update your application, please withdraw your existing one, shown here."
       #redirect_to(url_for(@job))
       redirect_to(url_for(existing))
       return
    end
  end

  def verify_applic_ownership
    a = @applic #Applic.find(params[:id])
    return if redirected_because(a.nil?, "Couldn't find that application.", jobs_path)
    return if redirected_because(a.user != current_user, "Only the original applicant can withdraw an application.", job_path(a.job))
  end

  def verify_applic_admin
    a = @applic #Applic.find(params[:id])
    return if redirected_because(a.nil?, "Couldn't find that application.", jobs_path)
    return if redirected_because( (a.user != current_user) && !a.job.allow_admin_by?(current_user), "You are not authorized to view that application.", job_path(a.job))
  end

  def verify_job_ownership
    j = @job #Job.find(params[:job_id])
    return if redirected_because(j.nil?, "Couldn't find that job.", jobs_path)
    return if redirected_because(! j.allow_admin_by?(current_user), "You are not authorized to view the applications for this job.", job_path(j))
  end

  def serve_document(type)
    return unless [:resume, :transcript].include?(type)
    @doc = @applic.send(type)
    return if redirected_because(@doc.nil?, "There was an error retrieving the requested document.", applic_path(@applic))
    send_file @doc.public_filename, :type => @doc.content_type
  end

  def send_applic_notification
    FacultyMailer.deliver_applic_notification(@applic)
  end

  public
  def resume
    serve_document(:resume)
  end

  def transcript
    serve_document(:transcript)
  end

  def show
    #@applic = Applic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @applic }
    end
  end

  def new
    #@job = Job.find(params[:job_id])
    
    if Applic.find(:first, :conditions => {:user_id => current_user.id, :job_id => @job.id})
       flash[:error] = "Whoa, slow down! You've already applied for this job."
       redirect_to(url_for(@job))
       return
    end
    
    @applic = Applic.new({:user => current_user, :job => @job})
  end

  # the action for actually applying.
  def create
    @applic = Applic.new({:user_id => current_user.id, :job_id => @job.id}.update(params[:applic]))
    @applic.resume_id     = current_user.resume.id     if params[:include_resume]     && current_user.resume.present?
    @applic.transcript_id = current_user.transcript.id if params[:include_transcript] && current_user.transcript.present?
    
    respond_to do |format|
        if @applic.save
            send_applic_notification
            flash[:notice] = 'Applied for job successfully. Time to cross your fingers and wait for a reply!'
            format.html { redirect_to job_path(@job) }
        else
            flash[:error] = "Could not apply to position. Make sure you've written " + 
                            "a message to the faculty sponsor!"
            #format.html { redirect_to(:controller=>:jobs, :action => :goapply, :id => params[:id]) }
            format.html { render :action => :new }
        end
    end
  end
  
  # withdraw from an application (destroy the applic)
  def destroy
    applic = Applic.find(:job_id=>params[:id])
    if !applic.nil? && applic.user == current_user
        respond_to do |format|
            if applic.destroy
                flash[:error] = "Withdrew your application successfully. Keep in mind that your initial application email has already been sent."
                format.html { redirect_to(:controller=>:jobs, :action=>:index) }
            else
                flash[:error] = "Couldn't withdraw your application. Try again, or contact support."
                format.html { redirect_to(:controller=>:dashboard) }
            end
        end
    else
        flash[:error] = "Error: Couldn't find that application."
        redirect_to(:controller=>:dashboard)
    end
  end

  def index
    flash[:notice] = "Application listing not implemented yet."
    redirect_to job_path(@job)
  end
 
end
