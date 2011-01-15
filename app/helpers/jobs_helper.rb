module JobsHelper
  def activation_url(job)
    #"#{$rm_root}jobs/activate/#{self.id}?a=#{job.activation_code}"
    "#{activate_job_url(job)}?a=#{job.activation_code}"
  end
end
