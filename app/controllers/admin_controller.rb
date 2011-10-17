class AdminController < ApplicationController
  before_filter :require_admin

private
  def require_admin
    unless @current_user and @current_user.user_type == User::Types::Admin
      redirect_to request.referer || home_path, :notice => "Insufficient priveleges"
    end
  end

end
