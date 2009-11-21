class DashboardController < ApplicationController
  before_filter :login_required
  
  def index
	@departments = Department.all
  end
end
