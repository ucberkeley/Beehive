require 'spec_helper'

describe "jobs/show.html.erb" do
  before(:each) do
    @job = assign(:job, stub_model(Job,
      :user => nil,
      :title => "Title",
      :desc => "MyText",
      :num_positions => 1,
      :department_id => 1,
      :activation_code => "Activation Code",
      :active => false
    ))
  end

  context "when authenticated with CAS" do
    before(:each) do 
      SpecHelperMethods.stub_cas_ok
    end
    
    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(//)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Title/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/MyText/)
    end
  end


end
