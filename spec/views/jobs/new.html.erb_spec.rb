require 'spec_helper'

describe "jobs/new.html.erb" do
  before(:each) do
    assign(:job, stub_model(Job,
      :user => nil,
      :title => "MyString",
      :desc => "MyText",
      :num_positions => 1,
      :department_id => 1,
      :activation_code => "MyString",
      :active => false
    ).as_new_record)
  end

  it "renders new job form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => jobs_path, :method => "post" do
      assert_select "input#job_user", :name => "job[user]"
      assert_select "input#job_title", :name => "job[title]"
      assert_select "textarea#job_desc", :name => "job[desc]"
      assert_select "input#job_num_positions", :name => "job[num_positions]"
      assert_select "input#job_department_id", :name => "job[department_id]"
      assert_select "input#job_activation_code", :name => "job[activation_code]"
      assert_select "input#job_active", :name => "job[active]"
    end
  end
end
