module CASControllerIncludes

  # this before_filter takes the results of the rubyCAS-client filter and sets up the current_user, 
  # thereby "logging you in" as the proper user in the ResearchMatch database.
  def setup_cas_user
    return unless session[:cas_user].present?
    @current_user = User.find_by_login(session[:cas_user])
    @current_user.present?
  end

end

