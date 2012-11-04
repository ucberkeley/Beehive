require 'spec_helper'

describe ContactUsController do
  describe "routing" do
    it "recognizes and generates #contact_us" do
      { :get => "contact_us/contact" }.should route_to(:controller => "contact_us", :action => "contact")
    end
    
    it "recognizes and generates #send_email" do
      { :post => "contact_us/send_email" }.should route_to(:controller => "contact_us", :action => "send_email")
    end
  end
end
