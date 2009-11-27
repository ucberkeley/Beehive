class DashboardController < ApplicationController
  before_filter :login_required
  
  def index
	@departments = Department.all
	@recently_added_jobs = Job.find(:all, :conditions => [ "active = ?", true], :order => "created_at DESC", :limit => 5 )
  end
end
