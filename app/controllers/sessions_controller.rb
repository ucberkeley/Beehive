# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  include CASControllerIncludes

  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :require_signed_up, :except => [:new]
  before_filter :set_setjmp, :only => [:new] # Remember previous page when logging in
  before_filter :dashboard_if_logged_in, :except => [:destroy]

  protected
  def dashboard_if_logged_in
    redirect_to dashboard_path if logged_in?
  end

  def set_setjmp
    puts "\n\n\n\n\n\nsetjmp = #{flash[:setjmp]} => "
    flash[:setjmp] = request.referer if flash[:setjmp].blank?
    puts "#{flash[:setjmp]}\n\n\n\n\n\n"
  end

  public

  # Don't render new.rhtml; instead, just redirect to dashboard, because  
  # we want to prevent people from accessing restful_authentication's 
  # user subsystem directly, instead using CAS.
  def new
     create
#    logout_keeping_session!
#    respond_to do |format|
#      format.html
#    end
  end

  def create
    # We should have a registered User at this point, due to the before_filter.
    logout_keeping_session!
    self.current_user = User.authenticate_by_login(session[:cas_user].to_s)
    if current_user.present?
      handle_remember_cookie! if params[:remember_me].eql?('1')
      flash[:notice] = 'Logged in successfully'
      redirect_to (flash[:setjmp] || dashboard_path)
      flash[:setjmp] = nil
    else # No User found
      flash[:error] = "There was a problem logging you in. Try again, <del>eat</del> clear your cookies, and if you still can't log in, please contact support."
      redirect_to login_path
    end
  end

  def destroy
    logout_killing_session!
    session[:cas_user] = nil
    
     # http://wiki.case.edu/Central_Authentication_Service: best practices: only logout app, not CAS

    flash[:notice] = "You have been logged out of ResearchMatch. If you'd like to log out of CAS completely, click <a class='caslogout' href='#{url_for :action=>:logout_cas}'>here</a>."
#    redirect_back_or_default(:controller=>"dashboard", :action=>:index) 
    #redirect_to :controller=>:dashboard, :action=>:index
    redirect_to '/'
  end

  def logout_cas
    CASClient::Frameworks::Rails::Filter.logout(self, url_for(:controller=>:dashboard, :action=>:index) )
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:email]}'. Check your email or password."
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
