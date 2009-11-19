class DashboardController < ApplicationController
  before_filter :logged_in?
  
  def index
	@departments = Department.all
	@user = current_user
  end
end
