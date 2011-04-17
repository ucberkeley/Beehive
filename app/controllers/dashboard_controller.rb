class DashboardController < ApplicationController
  before_filter :rm_login_required
  
  def index
      @user = current_user

      @departments = Department.all
      @recently_added_jobs = Job.find(:all, :conditions => ["active = ?", true], :order => "created_at DESC", :limit => 5 )
      #@relevant_jobs = Job.smartmatches_for(current_user, 4)

      @watched_jobs = current_user.watched_jobs

      @your_jobs = Job.find(:all, :conditions => [ "user_id = ?", current_user.id ])
  end  
end
