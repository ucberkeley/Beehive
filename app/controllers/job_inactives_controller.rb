class JobInactivesController < ApplicationController
  # GET /activate_job/1
  def activate
    @job_inactive = JobInactive.find(:activation_code => params[:code])
	if @job_inactive
	  # -----
	  @job_active = Job.new(:user => @job_inactive.user, :title => @job_inactive.title, :desc => @job_inactive.desc, :category => @job_inactive.category, :exp_date => @job_inactive.exp_date, :num_positions => @job_inactive.num_positions, :paid => @job_inactive.paid, :credit => @job_inactive.credit)
	  @job_active.save
	  redirect_to(@job_active)
	else
	  # render an error page
	end
  end
end
