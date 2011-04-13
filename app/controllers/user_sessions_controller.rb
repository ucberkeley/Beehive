class UserSessionsController < ApplicationController
  #CalNet / CAS Authentication
  before_filter CASClient::Frameworks::Rails::Filter

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :except => [:new, :create]

  def new
    # This should just redirect to CAS login
    return
    @user_session = UserSession.new
  end

  def create  # try making this crap a method in, say, app helper, then this can call it 
    logger.warn 'got to session create....'
    logger.warn 'params[:user_session] = ' + params[:user_session]
    @user_session = UserSession.new(params[:user_session])    
    create_user_session
  end

  def destroy
    s = current_user_session
    s.destroy if s
    session[:cas_user] = nil
    flash[:notice] = "Logout successful!"
    logout_cas
    logger.warn "OK: I just destroyed the user session"
  end
  
  def logout_cas
    CASClient::Frameworks::Rails::Filter.logout(self, url_for(:controller=>:home, :action=>:index) )
  end  

end
