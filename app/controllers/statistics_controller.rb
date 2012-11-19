class StatisticsController < ApplicationController

  before_filter :goto_home_unless_logged_in

  def index
    @total_users = User.all.count
    @num_active_users_in_last_month = User.where("last_request_at >= ?", DateTime.now - 1.month).count
    @num_active_users_this_month = User.where("last_request_at >= ?", DateTime.now.beginning_of_month).count

    @num_applics_in_last_month = Applic.where("created_at >= ?", DateTime.now - 1.month).count
    @num_applics_this_month = Applic.where("created_at >= ?", DateTime.now.beginning_of_month).count
    @num_applics_accepted_this_month = Applic.where("updated_at >= ? AND status = ?", DateTime.now - 1.month, 'accepted').count

    @total_active_jobs = Job.active_jobs.count
    @num_jobs_watched = Watch.all.count
    @num_new_jobs_in_last_month = Job.where("created_at >= ?", DateTime.now - 1.month).count
    @num_new_jobs_this_month = Job.where("created_at >= ?", DateTime.now.beginning_of_month).count

    @most_desired_courses = Coursereq.select('courses.name as cname, count(courses.id) as total').joins(:course).group('course_id').order('total desc').limit(8).map {|x| x.cname}
    @most_desired_proglangs = Proglangreq.select('proglangs.name as lname, count(proglangs.id) as total').joins(:proglang).group('proglang_id').order('total desc').limit(8).map {|x| x.lname}

  end
end
