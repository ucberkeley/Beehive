class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem    --- ^ did this.


  include CASControllerIncludes
  
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_course_name, 
		:auto_complete_for_category_name, :auto_complete_for_proglang_name]
  auto_complete_for :course, :name
  auto_complete_for :category, :name
  auto_complete_for :proglang, :name
  
  
    
  #CalNet / CAS Authentication
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :setup_cas_user, :except => [:new, :create]
  
  
  
  # Ensures that only this user -- and no other users -- can edit his/her profile
  before_filter :correct_user_access, :only => [ :edit, :update, :destroy ]

  
  def show 
    redirect_to :controller => :dashboard, :action => :index unless params[:id].to_s == current_user.id.to_s
  end
  
  # render new.rhtml
  def new
      @user = User.new(:login => session[:cas_user].to_s)
#      person = UCB::LDAP::Person.find_by_uid(session[:cas_user]) 

      if @user.ldap_person.nil?
        # TODO: what to do here?
        logger.warn "UsersController.new: Failed to find LDAP::Person for uid #{session[:cas_user]}"
        flash[:error] = "A directory error occurred. Please make sure you've authenticated with CalNet and try again."
        redirect_to '/'
      end

      @user.name  = @user.ldap_person_full_name
      @user.email = @user.ldap_person.email
      @user.update_user_type
  end
 
  def create
    logout_keeping_session!
    
    # See if this user was already created
    # TODO: handle this better
    if User.find_by_login(session[:cas_user].to_s) then
      flash[:error] = "You've already signed up." 
      redirect_to '/'
    end

    # Handles the text_field_with_auto_complete for courses, categories, and programming languages.
    params[:user][:course_names] = params[:course][:name] if params[:course]
    params[:user][:category_names] = params[:category][:name] if params[:category]
    params[:user][:proglang_names] = params[:proglang][:name] if params[:proglang]
    
    @user = User.new(params[:user])
    @user.login = session[:cas_user]
    @user.name = @user.ldap_person_full_name
    @user.update_user_type
    
    if @user.save && @user.errors.empty? then
      respond_to do |format|
        @user.activate! #FIXME: Remove this when we get ActionMailer up for email activations
        flash[:notice] = "Thanks for signing up! You're activated so go ahead and sign in." #FIXME: Change back when we get activation emails up
        #flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
        format.html { redirect_back_or_default(:controller=>"dashboard", :action=>:index) }
      end
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact support."
      # format.html { render :action => 'new' }
      redirect_to new_user_path
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default(:controller=>"dashboard", :action=>:index)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default(:controller=>"dashboard", :action=>:index)
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    # If params[:user] is blank? for some reason, instantiate it.
    if params[:user].blank? 
      params[:user] = {}
    end
    
	  # Handles the text_field_with_auto_complete for courses.
  	params[:user][:course_names] = params[:course][:name] if params[:course]
	
  	# Handles the text_field_with_auto_complete for categories.
  	params[:user][:category_names] = params[:category][:name]	if params[:category]

  	# Handles the text_field_with_auto_complete for proglangs.
  	params[:user][:proglang_names] = params[:proglang][:name]	if params[:proglang]	

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { render :action => :edit }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
	
	def correct_user_access
		if (User.find_by_id(params[:id]) == nil || current_user != User.find_by_id(params[:id]))
		  # flash[:error] = "params[:id] is " + params[:id] + "<br />"
		  # flash[:error] = "current_user is " + @current_user + "<br />"
		  flash[:error] += "Unauthorized access denied. Do not pass Go. Do not collect $200."
			redirect_to :controller => 'dashboard', :action => :index
		end
	end

end
