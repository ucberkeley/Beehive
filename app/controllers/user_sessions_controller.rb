class UserSessionsController < ApplicationController
#include CASControllerIncludes

#before_filter CASClient::Frameworks::Rails::Filter, :except => :destroy

  def new
    #if login_user!(User.find_by_login(session[:cas_user]))
    p auth_hash
    if login_user!(User.find_by_login(auth_hash[:uid]))
      redirect_to request.referer || home_path
    elsif !first_login
      # user's first login; redirect already done for us
      return
    else
      flash[:notice] = "There was a problem logging in.. please try again later, or contact us if the problem persists."
      flash[:notice] += @user_session.errors.inspect if Rails.env == 'development'
    end
  end

  def auth_hash
    session[:auth_hash] = request.env['omniauth.auth']
    request.env['omniauth.auth']
  end

  def destroy
    @user_session.destroy if @user_session
    @user_session = nil
    @current_user = nil
    if session[:auth_hash][:provider] == :cas
      CASClient::Frameworks::Rails::Filter.logout(self)
    else
      redirect_to home_path
    end
=begin
    @user_session.destroy if @user_session
    @user_session = nil
    @current_user = nil
    flash[:notice] = "Logged out successfully"
    redirect_to home_path
=end
  end
end
