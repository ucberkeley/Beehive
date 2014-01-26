# The mailer for feedback
class FeedbackMailer < ActionMailer::Base
  
  def send_feedback(sender, subject_line, body_text)
    recipients  'agnusmaximus@gmail.com'
    reply_to    sender
    from        sender
    subject     "[ResearchMatch Feedback] #{subject_line}"
    body        body_text
  end
end
