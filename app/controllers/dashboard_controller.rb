class DashboardController < ApplicationController
  before_filter :login_required
  
  def index
	@departments = Department.all
	@recently_added_jobs = Job.find(:all, :conditions => [ "active = ?", true], :order => "created_at DESC", :limit => 5 )
	@relevant_jobs = smartmatches_for current_user
	
  end
  
  protected
  
  def smartmatches_for(my)
	query = my.course_list_of_user.gsub ",", " "
	Job.find_by_solr(query.as_OR_query).results
  end
  
end
