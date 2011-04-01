require "spec_helper"

describe AttribsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/attribs" }.should route_to(:controller => "attribs", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/attribs/new" }.should route_to(:controller => "attribs", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/attribs/1" }.should route_to(:controller => "attribs", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/attribs/1/edit" }.should route_to(:controller => "attribs", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/attribs" }.should route_to(:controller => "attribs", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/attribs/1" }.should route_to(:controller => "attribs", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/attribs/1" }.should route_to(:controller => "attribs", :action => "destroy", :id => "1")
    end

  end
end
