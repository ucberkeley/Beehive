module CASControllerIncludes

  # this before_filter takes the results of the rubyCAS-client filter and sets up the current_user, 
  # thereby "logging you in" as the proper user in the ResearchMatch database.
  def setup_cas_user
    return unless session[:cas_user].present?
    @current_user = User.find_by_login(session[:cas_user])
    
    # if user doesn't exist, create it, and then redirect to edit profile page
    if @current_user.blank?

      #TODO: Set user metadata [obtained from LDAP] here, including user_type, rather than all 
      # this fake garbage data!!
      #     (note: the login here is correct; the rest is garbage)
#      @person = UCB::LDAP::Person.find_by_uid(session[:cas_user]) 
#      @current_user = User.new(
#                            :login => session[:cas_user].to_s,
#                            :name => "#{@person.firstname} #{@person.lastname}",
#                            :email => @person.email,
#                            :password => "password", 
#                            :password_confirmation => "password"
#                              ) # necessary to pass validations
                          
      # This has all been moved to users/new.
           
                              
      # @current_user.save!

      #redirect_to :controller => "users", :action => "edit", :id => @current_user.id
      redirect_to :controller => :users, :action => :new
      return false
    end
    
    @current_user.present?
  end

end

