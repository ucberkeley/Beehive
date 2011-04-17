module ApplicationHelper

  def current_user
    logger.debug "ApplicationController::current_user"
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # added by oren
  def logged_in?
    !!current_user
  end

  # Helper method called to actually create the user session a la Authlogic.
  def create_user_session    
    user_session_params = { :remember_me => 0, :login => session[:cas_user], 
      :password => "password" } 
      # password doesn't matter because we're authenticating via CAS 
      # and that's the only way to get through to the session now.
    @user_session = UserSession.new(user_session_params)
    @current_user = User.find_by_login(session[:cas_user].to_s)

    unless @current_user
      # TODO: Do stuff with ldap here.
      logger.warn 'TODO: Do stuff with ldap here'

      return false unless first_login
      return create_user_session
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

  def first_login
    # Called the first time a person logs in, i.e. after they've
    # passed CAS but no matching User was found.

    @current_user = User.new #(:login => session[:cas_user].to_s)
    @current_user.first_login(session[:cas_user])
    @current_user.save
    raise @current_user.errors.inspect unless @current_user.valid?
    redirect_to profile_path
    return false # halt the filter chain
  end
  
end

class String
  def pluralize_for(n=1)
    n == 1 ? self : self.pluralize
  end
end

class Object
  # Convenience method that calls the specified method on this object,
  # or returns nil (or another default) if this object is nil.
  #
  # @param meth method name to send to this object
  # @param default_value to return when SELF is nil
  #
  def get(meth, default_value=nil)
    return default_value if self.nil?
    self.send(*meth) rescue default_value
  end
end
