module JobsHelper
  def activation_url(job)
    puts "\n\n\nACTIVATION COOOOOODE" + job.activation_code.to_s + "\n\n\n\n"
    "#{ROOT_URL}#{activate_job_path(job)}?a=#{job.activation_code}"
  end
end
