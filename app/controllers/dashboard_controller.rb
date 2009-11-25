class DashboardController < ApplicationController
  before_filter :login_required
  
  def index
	@departments = Department.all
	@recently_added_jobs = Job.find_recently_added(5)
  end
end
