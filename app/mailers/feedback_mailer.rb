
# The mailer for feedback
class FeedbackMailer < ApplicationMailer

  def send_feedback(sender, subject_line, body_text)
    #recipients  'beehive-support@lists.berkeley.edu'
    #reply_to    sender
    #from        sender
    #subject     "[Beehive Feedback] #{subject_line}"
    #body        body_text
    mail(:to => 'beehive-support@lists.berkeley.edu',
         :from => sender,
         :reply_to => sender,
         :subject => "Beehive Feedback #{subject_line}",
         :body => body_text)
  end
end
