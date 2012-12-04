class AdminController < ApplicationController
  before_filter :require_admin

  def index
    roles = {User::Types::Undergrad => 'Undergrad', User::Types::Grad => 'Grad Student', User::Types::Faculty => 'Faculty', User::Types::Admin => 'Admin'}
    if params.has_key?('user_role') and params.has_key?('user_role_new')
      form_error = false
      error_msg = ["Oops! The following errors prevented the selected user from being updated!"]
      if params['user_role'] == ""
        form_error = true
        error_msg  << "1) No user selected."
      end
      if params['user_role_new'] == ""
        if form_error
          error_msg << "2) No role selected."
        else
          error_msg << "1) No role selected."
          form_error = true
        end
      end
      if form_error
        flash[:error] = error_msg.join("<br/>").html_safe
      else
        u = User.find_by_login(params['user_role'])
        u.user_type = params['user_role_new'].to_i
        u.save!
        flash[:notice] = "User #{u.name} successfully set as #{roles[u.user_type]}."
      end
    end
    @non_admins = []
    User.all.each do |i|
      if i.user_type == User::Types::Undergrad
        @non_admins << [i.name + " - Undergrad", i.login]
      end
      if i.user_type == User::Types::Grad
        @non_admins << [i.name + " - Grad Student", i.login]
      end
      if i.user_type == User::Types::Faculty
        @non_admins << [i.name + " - Faculty", i.login]
      end
    end
    @non_admins = @non_admins.sort
    @roles = [['Undergrad', 0], ['Grad Student', 1], ['Faculty', 2], ['Admin', 3]]
  end

private
  def require_admin
    unless @current_user and @current_user.user_type == User::Types::Admin
      redirect_to request.referer || home_path, :notice => "Insufficient priveleges"
    end
  end
end
