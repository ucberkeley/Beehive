class FacultyMailer < ActionMailer::Base
   @@rm_contact = "UC Berkeley ResearchMatch <ucbresearchmatch@gmail.com>"
   layout 'faculty_mailer'

   # HACK HACK HACK HACK HACK HACK
   # The 2 hours i spent figuring out how to work around the bug in ActionMailer
   # would probably have been better spent upgrading to Rails 3, where the bug
   # was fixed. :(
   #
   # See http://apidock.com/rails/ActionMailer/Base/render_message
   class TextPlain
     def initialize(template)         # render_message wants some object...
       @template = template
     end
     def to_s                         # that represents a filename...
       @template
     end
     def content_type                 # and also responds to content_type
       'text/plain'
     end
   end

   def self.format_recipient(name, email)
     "\"#{name}\" <#{email}>"
   end

   def faculty_confirmer(email, name, job)#job_id, job_title, job_description, activation_code)
     recipients FacultyMailer.format_recipient(name, email)
     from       "UC Berkeley ResearchMatch <ucbresearchmatch@gmail.com>"
     subject    "ResearchMatch Listing Confirmation"
     body       :email => email, :name => name, :job => job 
   end

   def applic_notification(applic)
     recipients FacultyMailer.format_recipient(applic.job.user.name, applic.job.user.email)
     from       @@rm_contact
     subject    "[ResearchMatch] Application Notification - #{applic.job.title[0..25]}"
     body       :applic => applic
     content_type 'multipart/alternative'

     # Implicit templates aren't used with attachments

     part 'text/plain' do |p|
       p.body = render_message(TextPlain.new('applic_notification.text.plain'), :applic=>applic)
       p.transfer_encoding = 'base64'
     end
     part :content_type => 'text/html', :body => render_message('applic_notification.text.html', :applic=>applic)

     [:resume, :transcript].each do |doctype|
       next unless doc = applic.send(doctype)
       attachment doc.content_type do |a|
         a.body     = File.read(doc.public_filename)
         a.filename = "#{doctype.to_s.capitalize!}.#{doc.public_filename.split('.').last}"
       end
     end
   end
end
