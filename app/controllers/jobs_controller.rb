class JobsController < ApplicationController

  # GET /jobs
  # GET /jobs.xml

  include CASControllerIncludes
  include AttribsHelper

  # skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_category_name,
    # :auto_complete_for_course_name, :auto_complete_for_proglang_name]
  # auto_complete_for :category, :name
  # auto_complete_for :course, :name
  # auto_complete_for :proglang, :name

  #CalNet / CAS Authentication
  #before_filter CASClient::Frameworks::Rails::Filter
  before_filter :goto_home_unless_logged_in

  # Ensures that only logged-in users can create, edit, or delete jobs
  before_filter :rm_login_required #, :except => [ :index, :show ]

  # Ensures that only the user who created a job -- and no other users -- can edit
  # or destroy it.
  before_filter :correct_user_access, :only => [ :edit, :update, :resend_activation_email,
                                                  :delete, :destroy ]

  before_filter :job_accessible, :only => [ :show, :apply ]

  # Prohibits a user from watching his/her own job
  before_filter :watch_apply_ok_for_job, :only => [ :watch ]

  protected
  def search_params_hash
    h = {}
    # booleans
    #h[:include_ended] = params[:include_ended] if ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:include_ended]) #unless params[param].nil?

    # strings, directly copy attribs
    [:query, :tags, :page, :per_page, :as, :compensation].each do |param|
      h[param] = params[param] unless params[param].blank?
    end

    # dept. 0 => all
    h[:post_status]     = params[:post_status]     if params[:post_status]
    h[:department] = params[:department] if params[:department].to_i > 0
    h[:faculty]    = params[:faculty]    if params[:faculty].to_i    > 0
    h
  end

  public

  def index #list
    # strip out some weird args
    # may cause double-request but that's okay
    redirect_to(search_params_hash) and return if [:commit, :utf8].any? {|k| !params[k].nil?}

    # Advanced search
    query_parms = {}
    query_parms[:department_id] = params[:department].to_i if params[:department] && params[:department].to_i > 0
    query_parms[:faculty_id   ] = params[:faculty].to_i    if params[:faculty] && params[:faculty].to_i > 0
    #query_parms[:include_ended] = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:include_ended])
    query_parms[:compensation ] = params[:compensation] if params[:compensation].present?
    query_parms[:tags         ] = params[:tags] if params[:tags].present?

    # will_paginate
    query_parms[:page         ] = params[:page]     || 1
    query_parms[:per_page     ] = params[:per_page] || 10

    @query = params[:query] || ''
    @jobs = Job.find_jobs(@query, query_parms)
    # Set some view props
    @department_id = params[:department]   ? params[:department].to_i : 0
    @faculty_id    = params[:faculty]      ? params[:faculty].to_i    : 0
    @compensation  = params[:compensation]

    respond_to do |format|
      format.html { render :action => :index }
      format.xml { render :xml => @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])
    @actions = @job.actions(@current_user)
    @curations = @job.curations(@current_user)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new(num_positions: 0)
    @faculty = Faculty.all
    # @faculty = Faculty.where("email != ? OR email != ?", "None", "nil")
    @current_owners = @job.owners.select{|i| i != @current_user}
    owners = @job.owners + [@job.user]
    @owners_list = User.all.select{|i| !(owners).include?(i)}.sort_by{|u| u.name}
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
    @job.mend

    @faculty = Faculty.all
    @current_owners = @job.owners.select{|i| i != @current_user}
    owners = @job.owners + [@job.user]
    @owners_list = User.all.sort_by{|u| u.name}
    respond_to do |format|
        format.html
        format.xml
    end

  end

  def resend_activation_email
    @job = Job.find(params[:id])
    @job.resend_email(true)
    flash[:notice] = 'Thank you. The activation email for this listing has '
    flash[:notice] << 'been re-sent to its faculty sponsors.'

    respond_to do |format|
      format.html { redirect_to(@job) }
    end
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @faculty = Faculty.all # used in form
    sponsor = Faculty.find(params[:faculty_id]) rescue nil
    @job = Job.create(job_params)
    @job.update(primary_contact_id: @current_user.id)
    @current_owners = @job.owners.select{|i| i != @current_user}
    owners = @job.owners + [@job.user]
    @owners_list = User.all.select{|i| !(owners).include?(i)}.sort_by{|u| u.name}
    @job.tag_list = @job.field_list

    respond_to do |format|
      if @job.save
        if sponsor
          @sponsorship = Sponsorship.find_or_create_by(faculty_id: sponsor.id, job_id: @job.id)
          @job.sponsorships << @sponsorship
        end
        flash[:notice] = 'Thank your for submitting a listing. It should now be available for other people to browse.'
        format.html { redirect_to(@job) }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        @faculty_id = params[:faculty_id]
        format.html { render 'new' }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    job_params
    @job = Job.find(params[:id])
    changed_sponsors = update_sponsorships and false # TODO: remove when :active is resolved
    @job.update_attribs(params)

    @faculty = Faculty.all
    @current_owners = @job.owners.select{|i| i != @current_user}
    owners = @job.owners + [@job.user]
    @owners_list = User.all.sort_by{|u| u.name}

    respond_to do |format|
      if @job.update_attributes(params[:job])
        if params.has_key?(:delete_owners) and params[:delete_owners].to_i >= 0
          @job.owners.delete(User.find(params[:delete_owners]))
        end
        @job.tag_list = @job.field_list

        # If the faculty sponsor changed, require activation again.
        # (require the faculty to confirm again)
        if changed_sponsors
          @job.resend_email(true) # sends the email too
        end
        flash[:notice] = 'Listing was successfully updated.'
        if params[:open_ended_end_date] == "true"
          @job.end_date = nil
        end

        @job.save
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
    @job = Job.find :first, conditions: { activation_code: params[:a] }

    unless @job
      flash[:error] = 'Unable to process activation request.'
      return redirect_to jobs_url
    end

    @job.populate_tag_list

    @job.skip_handlers = true

    unless @job.save
      flash[:error] = 'Unsuccessful activation. Please contact us if the problem persists.'
      return redirect_to(jobs_url)
    end

    @job.skip_handlers = false
    flash[:notice] = 'Listing activated successfully.  Your listing is now available to be viewed by other users.'
    redirect_to @job

  end

  def job_read_more
    job = Job.find(params[:id])
    render :plain => job.desc
  end

  def job_read_less
    job = Job.find(params[:id])
    desc = job.desc.first(100)
    desc = desc << "..." if job.desc.length > 100
    render :plain =>  desc
  end

  def watch
    job = Job.find(params[:id])
    watch = Watch.new({:user=> @current_user, :job => job})

    respond_to do |format|
      if watch.save
        flash[:notice] = 'Job is now watched. You can find a list of your watched jobs on the dashboard.'
        format.html { redirect_to(job) } #:controller=>:dashboard) }
      else
        flash[:notice] = 'Unsuccessful job watch. Perhaps you\'re already watching this job?'
        format.html { redirect_to(job) }
      end
    end
  end

  def unwatch
    job = Job.find(params[:id])
    @current_user.watches.find_by_job_id(job.id).destroy
    flash[:notice] = 'Job is now unwatched. You can find a list of your watched jobs on the dashboard.'
    redirect_to :back
  end



  protected

  # Processes form data for Job.update
  def job_params
    # TODO FIXME this sets the primary user as whoever is editing, which is quite broken.
    params[:job][:user_id] = @current_user.id
    params[:job][:end_date] = nil if params[:job].delete(:open_ended_end_date)

    # Handles the text_fields for categories, courses, and programming languages
    [:category, :course, :proglang].each do |k|
      params[:job]["#{k.to_s}_names".to_sym] = params[k][:name]
    end

    params[:job] = params.require(:job).permit(:title, :desc, :project_type,
      :user_id, :department_id, :status, :compensation, :num_positions,
      :end_date, :earliest_start_date, :latest_start_date,
      :category_names, :course_names, :proglang_names, :question_1, :question_2, :question_3)
    [:earliest_start_date, :latest_start_date, :end_date].each do |attribute|
      if params[:job][attribute].presence
        params[:job][attribute] = Date.parse(params[:job][attribute])
      end
    end
    params[:job]
  end


  # Saves sponsorship specified in the params page.
  # Returns true if sponsorships changed at all for this update,
  #   and false if they did not.
  def update_sponsorships
    # TODO allow more than one sponsor
    if params[:faculty_id] != '-1'
      @job.sponsorships.delete_all
      @job.sponsorships.create(faculty_id: params[:faculty_id])
    end
    return @job.sponsorships

  end

####################
#     FILTERS      #
####################

  private
  def correct_user_access
    job = Job.find(params[:id])
    if !job || !job.can_admin?(@current_user)
      flash[:error] = "You don't have permissions to edit or delete that listing."
      redirect_to :controller => 'dashboard', :action => :index
    end
  end

end
