class UserSessionsController < ApplicationController
include CASControllerIncludes

#before_filter CASClient::Frameworks::Rails::Filter, :except => :destroy

  # Entry point for user login
  def new
    auth_hash = request.env['omniauth.auth']
    session[:auth_provider] = auth_hash[:provider]

    # look up auth_field, auth_value of User by provider, from config/initializers/omniauth.rb
    # Currently CAS is our only provider
    auth_config = ResearchMatch::Application.config.auth_providers[session[:auth_provider].to_sym]
    if auth_config
      auth_field = auth_config[:auth_field].to_s
      auth_value = auth_hash[auth_config[:auth_value]].to_s
      session[:auth_field] = auth_field
      session[:auth_value] = auth_value
    else
      flash[:error] = "There were problems identifying your auth provider. Please try again or contact support."
      redirect_to home_path
      return
    end

    user = User.where(auth_field => auth_value).first
    if user.present?
      UserSession.new(user).save
      session[:user_id] = user.id # TODO remove (use only @user_session)
      redirect_to back
    else
      redirect_to new_user_path
    end
  end

  def destroy
    if @user_session
      @user_session.destroy
      @user_session = nil
      @current_user = nil
      self.send(:reset_session)
      session[:auth_provider] = session[:auth_field] = session[:auth_value] = nil
      session[:user_id] = nil
      # redirect to CAS logout
      CASClient::Frameworks::Rails::Filter.logout(self)
    else
      flash[:notice] = "You are already signed out."
      redirect_to home_path
    end
  end
end
