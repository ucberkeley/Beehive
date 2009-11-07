require 'spec_helper'

describe ReviewsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/reviews" }.should route_to(:controller => "reviews", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/reviews/new" }.should route_to(:controller => "reviews", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/reviews/1" }.should route_to(:controller => "reviews", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/reviews/1/edit" }.should route_to(:controller => "reviews", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/reviews" }.should route_to(:controller => "reviews", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/reviews/1" }.should route_to(:controller => "reviews", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/reviews/1" }.should route_to(:controller => "reviews", :action => "destroy", :id => "1") 
    end
  end
end
