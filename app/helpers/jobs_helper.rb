module JobsHelper
  def activation_url(job)
    activate_job_url(job, :a => job.activation_code)
  end
end
