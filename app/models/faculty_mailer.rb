class FacultyMailer < ActionMailer::Base
   def faculty_confirmer(email, name, job)#job_id, job_title, job_description, activation_code)
     recipients email
     from       "UC Berkeley ResearchMatch <ucbresearchmatch@gmail.com>"
     subject    "ResearchMatch Listing Confirmation"
     body       :email => email, :name => name, :job => job 
   end
end
