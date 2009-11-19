class DashboardController < ApplicationController
  before_filter :logged_in?
  
  def index
	@departments = Department.all
  end
end
