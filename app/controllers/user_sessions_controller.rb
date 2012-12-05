class UserSessionsController < ApplicationController
include CASControllerIncludes

#before_filter CASClient::Frameworks::Rails::Filter, :except => :destroy
#before_filter :goto_home_unless_logged_in, :except => :destroy

  def new
    session[:auth_hash] = request.env['omniauth.auth']

    # When using OmniAuth, different fields in the Users table can be used for
    # auth. Based on the provider, we the change auth_field to look at the
    # right Users column and change auth_value to match that provider's auth
    # details. Add these on to /config/initializers/omniauth.rb.



    auth_config = ResearchMatch::Application.config.auth_providers[session[:auth_hash][:provider].to_sym]
    if auth_config
      auth_field = auth_config[:auth_field].to_s
      auth_value = session[:auth_hash][auth_config[:auth_value]].to_s
    else
      flash[:error] = "There were problems identifying your auth provider. Please try again or contact support."
      redirect_to home_path
      return
    end

    user = User.where(auth_field => auth_value)
    user = user[0] if user.present?

    # This is used (temporarily) for the new/create routes for users. Right
    # now, those routes are not used in the logic of the app but are still
    # available. User creation is done in first_login.

    # cas_user should be removed entirely in a full transition away from CAS to
    # generic OmniAuth.
    if session[:auth_hash][:provider].to_sym == :cas
      session[:cas_user] = auth_value
    end

    if login_user!(user)
      session[:user_id] = user.id
      redirect_to home_path
    elsif !first_login(auth_field, auth_value)
      # user's first login; redirect already done for us
      return
    else
      flash[:notice] = "There was a problem logging in.. please try again later, or contact us if the problem persists."
      flash[:notice] += @user_session.errors.inspect if Rails.env == 'development'
    end
  end

  def destroy
    @user_session.destroy if @user_session
    @user_session = nil
    @current_user = nil
    if session[:auth_hash][:provider] == :cas or
      session[:auth_hash][:provider] == "cas"
      self.send(:reset_session)
      session[:auth_hash] = nil
      session[:user_id] = nil
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
