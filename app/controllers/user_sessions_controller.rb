class UserSessionsController < ApplicationController
  #CalNet / CAS Authentication
  before_filter CASClient::Frameworks::Rails::Filter

  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create  # try making this crap a method in, say, app helper, then this can call it 
    puts 'got to session create....'
    @user_session = UserSession.new(params[:user_session])
    @current_user = User.find_by_login(session[:cas_user].to_s)
    puts 'session created!!!!!!!!!!!!!!!!!'
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    session[:cas_user] = nil
    flash[:notice] = "Logout successful!"
    logout_cas
  end
  
  def logout_cas
    CASClient::Frameworks::Rails::Filter.logout(self, url_for(:controller=>:home, :action=>:index) )
  end  
end
