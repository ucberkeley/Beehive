class PostingMailer < ApplicationMailer
  def three_day_expire_notice
    target_date = Date.today + 3.days
    jobs = Job.where(status: 0).all.select do |j|
      same_day(j.latest_start_date, target_date) == true
    end
    jobs = User.find_by_email("shuang@berkeley.edu").jobs
    jobs.each do |job|
      @job = job
      mail(:to => @job.user.email, :subject => "Your Beehive job posting is about to expire").deliver
    end
  end

  def long_time_no_update_notice
    emails = [ENV["test_email_1"], ENV["test_email_2"]]
    emails.each do |a|
      mail(:to => a, :subject => "Please udpate your Beehive job posting").deliver
    end
  end

  private

  def same_day date1, date2
    if date1.year == date2.year && date1.month == date2.month && date1.day == date2.day
      return true
    end
    false
  end
end
