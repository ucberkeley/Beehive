# The mailer for jobs, e.g. to send activation emails out
# or to notify of applications to jobs
class JobMailer < ActionMailer::Base
  default_url_options[:host] = ROOT_URL
  default :from => "UCB ResearchMatch <ucbresearchmatch@gmail.com>"

  def activate_job_email(job)
    @job = job
    @faculty_sponsor_names = job.faculties.collect(&:name).join(", ")

    mail(:to => job.faculties.collect(&:email),
         :subject => "Research Listing Confirmation | UCB ResearchMatch")
  end

  def deliver_applic_email(applic)
    @applic = applic
    @job = applic.job

    [:resume, :transcript].each do |doctype|
      if @applic.send(doctype).present?
       attachments[@applic.user.name + '_' + doctype.to_s + '.' +
         @applic.send(doctype).public_filename.split('.').last] =
         File.read(@applic.send(doctype).public_filename)
      end
    end

    mail(:to => [@job.user.email] | @job.faculties.collect(&:email),
         :subject => "[ResearchMatch] Application for Research")
  end
end
