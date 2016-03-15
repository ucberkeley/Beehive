class UsersController < ApplicationController
  include AttribsHelper
  include CASControllerIncludes

  # skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_course_name,
  #   :auto_complete_for_category_name, :auto_complete_for_proglang_name]
  # auto_complete_for :course, :name
  # auto_complete_for :category, :name
  # auto_complete_for :proglang, :name

  #CalNet / CAS Authentication
  #before_filter CASClient::Frameworks::Rails::Filter
  before_filter :ensure_new_user, :only => [:new, :create]
  before_filter :rm_login_required, :except => [:new, :create]
  before_filter :correct_user_access, :only => [:edit, :update]
  before_filter :require_admin, :only => [:index, :delete]

  def show # TODO restrict access
    @user = User.find_by_id(params[:id])
    unless @user && (@user.jobs != nil && @user.jobs.length != 0)
      flash[:error] = 'We couldn\'t find that user.'
      redirect_to dashboard_path
    end
  end

  # Handles new users. Flow from user_sessions#new
  def new
    @user = User.new(session[:auth_field] => session[:auth_value])
    if params[:course].nil? # so edit view doesn't complain
      params[:course] = params[:proglang] = params[:category] = {}
    end

    if session[:auth_provider].to_sym == :cas
      unless @user.fill_from_ldap
        logger.warn "UsersController.new: Failed to find LDAP::Person for uid #{session[:auth_value]}"
      end
    end
  end

  # Create account for a new user.
  def create
    new # set @user
    if @user.apply?
      @user.handle_courses(params[:course][:name])
      @user.handle_proglangs(params[:proglang][:name])
      @user.handle_categories(params[:category][:name])
    end
    @user.assign_attributes(user_params)

    if @user.save && @user.errors.empty?
      flash[:notice] = 'Your profile was successfully updated.'
      redirect_to jobs_path
    else
      render 'new'
    end
  end

  # Edit any user (only be available to Admin)
  def edit
    @user = User.find(params[:id])
    prepare_attribs_in_params(@user)
  end

  def profile
    @user = @current_user
    prepare_attribs_in_params(@user)
    render :edit
  end

  def update
    if @current_user.apply?
      @current_user.handle_courses(params[:course][:name])
      @current_user.handle_proglangs(params[:proglang][:name])
      @current_user.handle_categories(params[:category][:name])
    end
    if @current_user.update_attributes(user_params)
      flash[:notice] = 'Your profile was successfully updated.'

      redirect_to profile_path
    else
      @user = @current_user
      render :edit
    end
  end

  def index
    @users = User.order(:name).page(params[:page])
  end



  private
    def correct_user_access
      user_id = User.find_by_id(params[:id])
      if user_id == nil || (@current_user != user_id && !@current_user.admin?)
        flash[:error] = "Sorry, you can't access that."
        redirect_to :controller => 'dashboard', :action => :index
      end
    end

    def ensure_new_user
      if @current_user
        flash[:warning] = "You're already signed up."
        redirect_to profile_path
        return false
      end
      return true if session[:auth_value]
      (redirect_to login_path) and false
    end

    def user_params
      params.require(:user).permit(:email, :major_code ,:class_of, :free_hours, :experience, :url, :research_blurb)
    end
end
