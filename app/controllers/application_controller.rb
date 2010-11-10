# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
 
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  before_filter :current_user_if_logged_in
  
  def current_user_if_logged_in
	  @user = current_user if logged_in?
  end
  
  # Puts a flash[:notice] error message and redirects if condition isn't true.
  # Returns true if redirected.
  #
  # Usage: return if redirected_because(!user_logged_in, "Not logged in!", "/diaf")
  #
  def redirected_because(condition=true, error_msg="Error!", redirect_url=nil)
    return false if condition == false or redirect_url.nil?
    flash[:error] = error_msg
    redirect_to redirect_url unless redirect_url.nil?
    return true
  end
  
end
