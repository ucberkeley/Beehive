module JobsHelper
  def activation_url(job)
    "#{ROOT_URL}#{activate_job_path(job)}?a=#{job.activation_code}"
  end
end
