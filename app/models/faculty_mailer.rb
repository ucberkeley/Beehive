class FacultyMailer < ActionMailer::Base
   @@rm_contact = "UC Berkeley ResearchMatch <ucbresearchmatch@gmail.com>"

   def faculty_confirmer(email, name, job)#job_id, job_title, job_description, activation_code)
     recipients email
     from       "UC Berkeley ResearchMatch <ucbresearchmatch@gmail.com>"
     subject    "ResearchMatch Listing Confirmation"
     body       :email => email, :name => name, :job => job 
   end

   def applic_notification(applic)
     recipients applic.subscriber_emails
     from       @@rm_contact
     subject    "[ResearchMatch] Application Notification - #{applic.job.title[0..25]}"
     body       :applic => applic
     content_type 'multipart/alternative'

     # Implicit templates aren't used with attachments

     part :content_type => 'text/html', :body => render_message('applic_notification.text.html', :applic=>applic)
     part :content_type => 'text/plain' do |p|
       p.body = render_message('applic_notification.text.plain', :applic=>applic)
       p.transfer_encoding = 'base64'
     end

     [:resume, :transcript].each do |doctype|
       next unless doc = applic.send(doctype)
       attachment doc.content_type do |a|
         a.body     = File.read(doc.public_filename)
         a.filename = "#{doctype.to_s.capitalize!}.#{doc.public_filename.split('.').last}"
       end
     end
   end
end
