# run with: rails runner script/data/convert_paid_and_credit_to_compensation.rb

for job in Job.all do
  if job.compensation.blank?
    if (job.credit? && job.paid?)
      job.compensation = "Paid or Credit"
    elsif job.credit?
      job.compensation = "Credit Only"
    elsif job.paid?
      job.compensation = "Paid Only"
    else
      job.compensation = "Unspecified"
    end
    print "."
    job.save
  end
end
puts ""
puts "conversion finished"