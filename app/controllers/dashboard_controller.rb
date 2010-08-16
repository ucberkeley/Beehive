class DashboardController < ApplicationController
  before_filter :login_required
  
  def index
	  @departments = Department.all
  	@recently_added_jobs = Job.find(:all, :conditions => [ "active = ?", true], :order => "created_at DESC", :limit => 5 )
  	@relevant_jobs = smartmatches_for(current_user)[0..3]
	
  	@watched_jobs = []
  	for w in current_user.watches
  		@watched_jobs << w.job
  	end
	
  	@your_jobs = []
  	for j in Job.find(:all, :conditions => [ "user_id = ?", current_user.id ])
  		@your_jobs << j
  	end
	
  end  
end
