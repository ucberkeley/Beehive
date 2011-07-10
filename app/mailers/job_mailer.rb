# The mailer for jobs, e.g. to send activation emails out
class JobMailer < ActionMailer::Base
  default_url_options[:host] = "localhost:3000"
  #TODO: Set this localhost:3000 / the actual host name to be a global uniform
  # variable someplace that we refer to!!!!

  default :from => "UCB ResearchMatch <ucbresearchmatch@gmail.com>"

  def activate_job_email(job)
    @job = job
    @faculty_sponsor_names = ""
    job.faculties.map(&:name).each do |name|
      @faculty_sponsor_names << name
    end

    mail(:to => job.faculties.map(&:email).join("& "),
         :subject => "Research Listing Confirmation | UCB ResearchMatch")
  end
end
