namespace :job_post do
  desc "Sending three day expire notice..."
  task :three_day_expire_notice => :environment do
    target_date = Date.today + 3.days
    jobs = Job.where(status: 0).all.select do |j|
      same_day(j.latest_start_date, target_date) == true
    end
    jobs = User.find_by_email("shuang@berkeley.edu").jobs
    jobs.each do |job|
      PostingMailer.three_day_expire_notice(job)
    end
  end

  desc "Sending long time no update notice..."
  task :long_time_no_update_notice => :environment do
    emails = [ENV["test_email_1"], ENV["test_email_2"]]
    emails.each do |email|
      PostingMailer.long_time_no_update_notice(email)
    end
  end
end

def same_day date1, date2
  if date1.year == date2.year && date1.month == date2.month && date1.day == date2.day
    return true
  end
  false
end