module ApplicationHelper

  # Helper method called to actually create the user session a la Authlogic.
  def create_user_session    
    user_session_params = { :remember_me => 0, :login => session[:cas_user], 
      :password => "password" } 
      # password doesn't matter because we're authenticating via CAS 
      # and that's the only way to get through to the session now.
    @user_session = UserSession.new(user_session_params)

    if ! User.exists?(:login => session[:cas_user].to_s)
      # TODO: Do stuff with ldap here.
      logger.warn 'TODO: Do stuff with ldap here'
    else
      @current_user = User.find_by_login(session[:cas_user].to_s)    
    end

    if @user_session.save
      flash[:notice] = "Login successful!"
    else
      logger.warn '@user_session did not save successfully.'
    end
  end

  # The workhorse filter for authentication.
  # First, checks for CAS authentication, 
  # via 'before_filter CASClient::Frameworks::Rails::Filter'.
  # Then, sets up the user via LDAP if 
  # the user does not yet exist, and then creates 
  # the proper UserSession.
  def rm_login_required
    return false unless CASClient::Frameworks::Rails::Filter.filter(self)
    
    logger.warn 'session[:cas_user] at this point is: ' + session[:cas_user].to_s
    # If it's present, means we authenticated with CAS successfully 
    # and need to create the user session in rails, unless 
    # we already have a session.
    if session[:cas_user].present? && ! logged_in?
      logger.warn 'session[:cas_user].present? && ! logged_in?'
      create_user_session
      
    elsif session[:cas_user].blank?
      logger.warn 'logged_in? is: ' + logged_in?.to_s
      logger.warn 'session[:cas_user].blank?'
      flash[:error] = "Could not log in successfully."
      #redirect_back_or_default(root_url)
    end
  end
  
  module NonEmpty
	    def nonempty?
	        not self.nil? and not self.empty?
	    end
	end
end

class String
    include ApplicationHelper::NonEmpty
    
    # Translates \n line breaks to <br />'s.
    def to_br
        self.gsub("\n", "<br />")
    end

    def pluralize_for(n=1)
      n == 1 ? self : self.pluralize
    end
    
end
