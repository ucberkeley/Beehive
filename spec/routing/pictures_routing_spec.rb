require 'spec_helper'

describe PicturesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/pictures" }.should route_to(:controller => "pictures", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/pictures/new" }.should route_to(:controller => "pictures", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/pictures/1" }.should route_to(:controller => "pictures", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/pictures/1/edit" }.should route_to(:controller => "pictures", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/pictures" }.should route_to(:controller => "pictures", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/pictures/1" }.should route_to(:controller => "pictures", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/pictures/1" }.should route_to(:controller => "pictures", :action => "destroy", :id => "1") 
    end
  end
end
