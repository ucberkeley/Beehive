require 'spec_helper'

describe "jobs/index.html.erb" do
  before(:each) do
    assign(:jobs, [
      stub_model(Job,
        :user => nil,
        :title => "Title",
        :desc => "MyText",
        :num_positions => 1,
        :department_id => 1,
        :activation_code => "Activation Code",
        :active => false
      ),
      stub_model(Job,
        :user => nil,
        :title => "Title",
        :desc => "MyText",
        :num_positions => 1,
        :department_id => 1,
        :activation_code => "Activation Code",
        :active => false
      )
    ])
  end

  it "renders a list of jobs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Activation Code".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
