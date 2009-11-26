class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem    --- ^ did this.
  
  auto_complete_for :course, :name

  # render new.rhtml
  def new
    @user = User.new
    
	# set up list of faculty names
	@all_faculty = Faculty.find(:all)
    @faculty_names = []
    @all_faculty.each do |faculty|
      @faculty_names << faculty.name
	end
  end
 
  def create
    logout_keeping_session!

	# set up list of faculty names
    @all_faculty = Faculty.find(:all)
    @faculty_names = []
    @all_faculty.each do |faculty|
      @faculty_names << faculty.name
	end

	# Assign the faculty email parameter based on the faculty name chosen from the select dropdown.
	params[:user][:faculty_email] = Faculty.find(:first, :conditions => [ "name = ?", params[:user][:faculty_name] ]).email
    
	
	@user = User.new(params[:user])
	
    success = @user && @user.save

    if success && @user.errors.empty?
	  @user.activate!
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
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


    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'user was successfully updated.'
        format.html { redirect_to :controller => :dashboard }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
