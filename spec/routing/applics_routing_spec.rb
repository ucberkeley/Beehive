require "spec_helper"

describe ApplicsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/applics" }.should route_to(:controller => "applics", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/applics/new" }.should route_to(:controller => "applics", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/applics/1" }.should route_to(:controller => "applics", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/applics/1/edit" }.should route_to(:controller => "applics", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/applics" }.should route_to(:controller => "applics", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/applics/1" }.should route_to(:controller => "applics", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/applics/1" }.should route_to(:controller => "applics", :action => "destroy", :id => "1")
    end

  end
end
