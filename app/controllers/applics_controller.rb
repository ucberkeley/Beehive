class ApplicsController < ApplicationController
  include CASControllerIncludes
  before_filter :rm_login_required

  before_filter :find_objects

  # These filters verify that @current_user has the right permissions
  before_filter :verify_applic_ownership, :only => [:destroy]
    # only applicant can withdraw
  before_filter :verify_applic_admin,     :only => [:show, :resume, :transcript]
    # applicant, job admin can view applic
  before_filter :verify_job_ownership,    :only => [:index, :delete]
    # show applics only if can admin
  before_filter :verify_job_unapplied,    :only => [:create]
    # don't allow multiple applications

  before_filter :job_accessible, :only => [ :new, :create, :index ]

  # Prohibits a user from applying to his/her own job
  before_filter :watch_apply_ok_for_job, :only => [ :new, :create ]

  protected
  def find_objects
    @applic = Applic.find(params[:id])  unless params[:id].blank?
    @job    = Job.find(params[:job_id]) unless params[:job_id].blank?
  end

  def verify_job_unapplied
    existing = Applic.where({:user_id => @current_user, :job_id => @job.id, :applied => true}).first
    if existing
      flash[:error] = "Whoa, slow down! You've already applied for this job. "
      flash[:error] << "If you'd like to update your application, please "
      flash[:error] << "withdraw your existing one first."
      redirect_to(url_for(existing))
      return false
    else
      return true
    end
  end

  def verify_applic_ownership
    a = @applic #Applic.find(params[:id])
    return if redirect_if(a.nil?, "Couldn't find that application.", jobs_path)
    return if redirect_if(a.user != @current_user,
      'Only the original applicant can withdraw an application.', job_path(a.job))
  end

  def verify_applic_admin
    a = @applic #Applic.find(params[:id])
    return if redirect_if(a.nil?, "Couldn't find that application.", jobs_path)
    return if redirect_if(a.user == @current_user || !a.job.can_admin?(@current_user),
      'You are not authorized to view that application.', job_path(a.job))
  end

  def verify_job_ownership
    j = @job #Job.find(params[:job_id])
    a = @applic
    return if redirect_if(j.nil? && a.nil?, "Couldn't find that job.", jobs_path)
    if !j.nil?
      return if redirect_if(! j.can_admin?(@current_user),
        "You are not authorized to view the applications for this job.",
        job_path(j))
    else
      return if redirect_if(! a.job.can_admin?(@current_user),
        "You are not authorized to view the applications for this job.",
        job_path(a.job))
    end
  end

  def serve_document(type)
    return unless [:resume, :transcript].include?(type)
    @doc = @applic.send(type)
    return if redirect_if(@doc.nil?,
      "There was an error retrieving the requested document.",
      applic_path(@applic))
    send_file @doc.public_filename, :type => @doc.content_type
  end

  public
  def resume
    serve_document(:resume)
  end

  def transcript
    serve_document(:transcript)
  end

  def show
    @applic = Applic.find(params[:id])
    @status = @applic.status.nil? ? 'Undecided' : @applic.status.capitalize

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @applic }
    end
  end

  def new
    if verify_job_unapplied
      @applic = Applic.find_or_initialize_by({:user => @current_user, :job => @job})
    else
      redirect_to(url_for(@job))
    end

  end

  # the action for actually applying.
  def create
    @applic = Applic.where({:user_id => @current_user.id, :job_id => @job.id}).first
    if @applic
      @applic.message = params[:applic][:message]
      @applic.answer_1 = params[:applic][:answer_1]
      @applic.answer_2 = params[:applic][:answer_2]
      @applic.answer_3 = params[:applic][:answer_3]
    else
      @applic = Applic.new({:user_id => @current_user.id, :job_id => @job.id}.update(params[:applic]))
    end

    if (@job.question_1 != nil && @job.question_1 != "" && (@applic.answer_1 == nil || @applic.answer_1 == "")) ||
       (@job.question_2 != nil && @job.question_2 != "" && (@applic.answer_2 == nil || @applic.answer_2 == "")) ||
       (@job.question_3 != nil && @job.question_3 != "" && (@applic.answer_3 == nil || @applic.answer_3 == ""))
       flash[:error] = "Could not apply to position. Make sure you've " +
                        "answered faculty questions"
      render'new'
      return
    end

    @applic.resume_id = @current_user.resume.id if params[:include_resume] &&
      @current_user.resume.present?
    @applic.transcript_id = @current_user.transcript.id if
      params[:include_transcript] && @current_user.transcript.present?
    # submit an application
    if params[:commit] == 'Submit'
      # update an existing application
      @applic.applied = true
      if @applic.save
        # Validate and send emails
        user_email = @job.user.email
        contact_email = @job.contacter.email

        if !contact_email.empty?
          JobMailer.deliver_applic_email(@applic, contact_email).deliver
          flash[:notice] = 'Application sent. Time to cross your fingers and wait for a reply!'
        else
          flash[:error] = "Looks like the job's contacts have invalid emails.
                           Please contact us for further support.
                           Your application has been submitted."
        end
        redirect_to job_path(@job)
      else
        flash[:error] = "Could not apply to position. Make sure you've " +
                        "written a message to the faculty sponsor!"
        render 'new'
      end

    else # save an application
      @applic.applied = false

      if @applic.save
        flash[:notice] = 'Application saved. You can come back later and complete your application!'
        redirect_to job_path(@job)
      else
        flash[:error] = "Could not save application. Make sure you've " +
                        "written a message to the faculty sponsor!"
        render 'new'
      end
    end
  end

  def delete
    applic = Applic.find_by_id(params[:id])
    job_id = applic.job_id.to_s
    if !applic.nil?
      applic.status = "not accepted"
      applic.save
      flash[:notice] = "Applicants %s was rejected/removed" % applic.user.name
    end
    redirect_to('/jobs/%s' % job_id)
  end

  # withdraw from an application (destroy the applic)
  def destroy
    applic = Applic.find(:job_id=>params[:id])
    if !applic.nil? && applic.user == @current_user
      respond_to do |format|
        if applic.destroy
          flash[:error] = "Withdrew your application successfully. "
          flash[:error] << "Keep in mind that your initial application "
          flash[:error] << "email has already been sent."
          format.html { redirect_to(:controller=>:jobs, :action=>:index) }
        else
          flash[:error] = "Couldn't withdraw your application. "
          flash[:error] << "Please try again, or contact support."
          format.html { redirect_to(:controller=>:dashboard) }
        end
      end
    else
      flash[:error] = "Error: Couldn't find that application."
      redirect_to(:controller=>:dashboard)
    end
  end

  def accept
    applic = Applic.find_by_id(params[:applic_id])
    if !applic.nil?
      applic.status = "accepted"
      applic.save
      flash[:notice] = "Applicant %s was accepted" % applic.user.name
    end
    redirect_to('/applics/applications/%s' % applic.id)
  end

  def unaccept
    applic = Applic.find_by_id(params[:applic_id])
    job_id = applic.job_id.to_s
    if !applic.nil?
      applic.destroy
      flash[:notice] = "Accepted hire %s was removed" % applic.user.name
    end
    redirect_to job_path(job_id)
  end

  def index
    flash[:notice] = "Application listing not implemented yet."
    redirect_to job_path(@job)
  end
end
