require 'spec_helper'

describe FeedbackMailer do
  
  describe "#send_feedback()" do
    
    it "sends an email using its parameters (as sender, subject_line, body_text)" do
      email = FeedbackMailer.send_feedback("dtrump@money.com", "Important News", "You're Fired!").deliver
      ActionMailer::Base.deliveries.should_not be_empty
      email.to.should include "beehive-support@lists.berkeley.edu"
      email.to.should include "beehive-support@lists.berkeley.edu"
      email.reply_to.should include "dtrump@money.com"
      email.from.should include "dtrump@money.com"
      email.subject.should == "Important News"
      email.body.should == "You're Fired!"
    end
  end      
end