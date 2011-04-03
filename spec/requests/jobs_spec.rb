require 'spec_helper'

describe "Jobs" do
  describe "GET /jobs (with CAS logged in)" do
    it "works? (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      SpecHelperMethods.stub_cas_ok
      get jobs_path
      response.status.should be(200)
    end
  end
  
  describe "GET /jobs (with CAS logged out)" do
    it "works? (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get jobs_path
      response.status.should be(302)
    end
  end
end
