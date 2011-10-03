# The mailer for feedback
class FeedbackMailer < ActionMailer::Base
  
  def send_feedback(sender, subject_line, body_text)
    recipients  'ucbresearchmatch@gmail.com'
    reply_to    sender
    from        sender
    subject     subject_line
    body        body_text
  end
end
