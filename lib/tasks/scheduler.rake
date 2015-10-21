desc "This task is called by the Heroku scheduler add-on"
task :close_jobs => :environment do
  Jobs.close_jobs
end
