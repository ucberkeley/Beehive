class UserSessionsController < ApplicationController
  include CASControllerIncludes

  before_filter CASClient::Frameworks::Rails::Filter

  def new
    unless login_user!(User.find_by_login(session[:cas_user]))
      flash[:notice] = "There was a problem logging in.. please try again later, or contact us if the problem persists."
      flash[:notice] += @user_session.errors.inspect if Rails.env == 'development'
    end
    redirect_to request.referer || home_path
  end

  def destroy
    if @user_session
      @user_session.destroy
      @user_session = nil
      @current_user = nil
      flash[:notice] = "Logged out successfully"
    end
    redirect_to home_path
  end
end
