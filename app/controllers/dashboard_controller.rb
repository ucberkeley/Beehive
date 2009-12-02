class DashboardController < ApplicationController
  before_filter :login_required
  
  def index
	@departments = Department.all
	@recently_added_jobs = Job.find(:all, :conditions => [ "active = ?", true], :order => "created_at DESC", :limit => 5 )
	@relevant_jobs = smartmatches_for(current_user)[0..3]
	
	watched_jobs = current_user.watches
	@watched_jobs = []
	for w in watched_jobs
		@watched_jobs << w.job
	end
	
  end  
end
