class PostingMailer < ApplicationMailer
  def three_day_expire_notice job
    @job = job
    mail(:to => @job.user.email, :subject => "Your Beehive job posting is about to expire").deliver
  end

  def long_time_no_update_notice email
    mail(:to => email, :subject => "Please udpate your Beehive job posting").deliver
  end
end
