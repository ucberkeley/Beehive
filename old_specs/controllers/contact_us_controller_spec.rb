require 'spec_helper'

describe ContactUsController do
  fixtures :users
  integrate_views
  
  describe "#contact" do
    
    context "with a user logged in" do
      
      before do
        Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(self)
        @user = users(:quentin)
        login = UserSession.create(@user)
        login.should be_true
        get :contact
      end
      
      it "properly assigns @user_email for use in the view" do
        assigns(:user_email).should == @user.email
      end
      
      it "renders contact_us/contact page" do
        response.should render_template "contact"
      end
      
      it "renders a form" do
        response.body.should match "label"
        response.body.should match "input"
        response.body.should match "textarea"
        response.body.should match "submit"
      end
    end
    
    context "with no user logged in" do
      it "redirects to the current page with a reasonable flash notice" do
        request.env["HTTP_REFERER"] = "/dashboard"
        get :contact
        flash[:notice].should == "You must be logged in to leave feedback"
        response.should redirect_to "/dashboard"
      end
    end
  end
  
  describe "#send_email" do
    
    it "calls FeedbackMailer.send_feedback.deliver with proper arguments" do
      @mail = FeedbackMailer.send_feedback("fake sender", "fake subject", "fake body")
      FeedbackMailer.stub!(:send_feedback).and_return(@mail)
      FeedbackMailer.should_receive(:send_feedback).with("mark_zuckerberg@fb.com", "poke you", "don't poke me back!")
      post :send_email, :sender => "mark_zuckerberg@fb.com", :subject => "poke you", :body => "don't poke me back!"
    end
    
    it "redirects to /dashbaord with an appropriate flash notice" do
      post :send_email, :sender => "mark_zuckerberg@fb.com", :subject => "poke you", :body => "don't poke me back!"
      flash[:notice].should == "Your message has been sent. Thanks for your feedback!"
      response.should redirect_to "/dashboard"
    end
  end
end
