class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem    --- ^ did this.
  
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_course_name, 
		:auto_complete_for_category_name, :auto_complete_for_proglang_name]
  auto_complete_for :course, :name
  auto_complete_for :category, :name
  auto_complete_for :proglang, :name
  
  # Ensures that only this user -- and no other users -- can edit his/her profile
  before_filter :correct_user_access, :only => [ :edit, :update, :destroy ]
  
  
  # render new.rhtml
  def new
    @user = User.new
    
	  # set up list of faculty names
	  @all_faculty = Faculty.find(:all)
    @faculty_names = @all_faculty.map {|f| f.name }

  end
 
  def create
    logout_keeping_session!
    
	  # set up list of faculty names
    @all_faculty = Faculty.find(:all, :order => :id)
    @faculty_names = @all_faculty.map {|f| f.name }
	  
  	# Handles the text_field_with_auto_complete for courses, categories, and programming languages.
  	params[:user][:course_names] = params[:course][:name]
  	params[:user][:category_names] = params[:category][:name]
  	params[:user][:proglang_names] = params[:proglang][:name]
	
  	@user = User.new(params[:user])
	
    success = @user && @user.save
    if success && @user.errors.empty?
	    @user.activate! #FIXME: Remove this when we get ActionMailer up for email activations
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up! You're activated so go ahead and sign in." #FIXME: Change back when we get activation emails up
      #flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact support."
      render :action => 'new'
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
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def edit
  end
  
  def update
    @user = User.find(params[:id])
	
	  # Handles the text_field_with_auto_complete for courses.
  	params[:user][:course_names] = params[:course][:name]
	
  	# Handles the text_field_with_auto_complete for categories.
  	params[:user][:category_names] = params[:category][:name]	

  	# Handles the text_field_with_auto_complete for proglangs.
  	params[:user][:proglang_names] = params[:proglang][:name]		

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to :controller => :dashboard }
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
			flash[:notice] = "Unauthorized access denied. Do not pass Go. Do not collect $200."
			redirect_to :controller => 'dashboard', :action => :index
		end
	end

end
