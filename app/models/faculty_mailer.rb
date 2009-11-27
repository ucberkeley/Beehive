class FacultyMailer < ActionMailer::Base
   def faculty_confirmer(email, name, job_title, job_description, activation_code)
     recipients email
     from       "system"
     subject    "ResearchMatch Job Posting Confirmation"
     body       :email => email, :name => name, :activation_code => activation_code, :job_title => job_title, :job_description => job_description
   end
end
