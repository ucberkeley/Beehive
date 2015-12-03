class StatisticsController < ApplicationController

    before_filter :rm_login_required

    def index
        @total_users = User.all.count
        @num_active_users_in_last_month = User.where("last_request_at >= ?", DateTime.now - 1.month).count
        @num_active_users_this_month = User.where("last_request_at >= ?", DateTime.now.beginning_of_month).count

        @num_applics_in_last_month = Applic.where("created_at >= ?", DateTime.now - 1.month).count
        @num_applics_this_month = Applic.where("created_at >= ?", DateTime.now.beginning_of_month).count
        @num_applics_accepted_this_month = Applic.where("updated_at >= ? AND status = ?", DateTime.now - 1.month, 'accepted').count

        @total_jobs = Job.count
        @num_jobs_watched = Watch.all.count
        @num_new_jobs_in_last_month = Job.where("created_at >= ?", DateTime.now - 1.month).count
        @num_new_jobs_this_month = Job.where("created_at >= ?", DateTime.now.beginning_of_month).count

        @most_desired_courses = Coursereq.select('courses.name as cname, count(course_id) as total').joins(:course).group('course_id', 'courses.name').order('total desc').limit(8).map {|x| x.cname}
        @most_desired_proglangs = Proglangreq.select('proglangs.name as lname, count(proglang_id) as total').joins(:proglang).group('proglang_id', 'proglangs.name').order('total desc').limit(8).map {|x| x.lname}
    end
end
