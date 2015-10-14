
# The mailer for jobs, e.g. to send activation emails out
# or to notify of applications to jobs
class JobMailer < ApplicationMailer
  def activate_job_email(job)
    @job = job
    @faculty_sponsor_names = job.faculties.collect(&:name).join(", ")

    mail(:to => job.faculties.collect(&:email),
         :subject => "Project Listing Confirmation | Berkeley Beehive")
  end

  def deliver_applic_email(applic, contact_email)
    @applic = applic
    @job = applic.job

    [:resume, :transcript].each do |doctype|
      if @applic.respond_to? doctype
       attachments[@applic.user.name + '_' + doctype.to_s + '.' +
         @applic.send(doctype).public_filename.split('.').last] =
         File.read(@applic.send(doctype).public_filename)
      end
    end

    mail(:to => contact_email,
         :subject => "[Beehive] Project Application")
  end
end
