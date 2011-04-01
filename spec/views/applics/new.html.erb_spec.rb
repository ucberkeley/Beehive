require 'spec_helper'

describe "applics/new.html.erb" do
  before(:each) do
    assign(:applic, stub_model(Applic,
      :job => nil,
      :user => nil,
      :message => "MyText",
      :resume_id => 1,
      :transcript_id => 1
    ).as_new_record)
  end

  it "renders new applic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => applics_path, :method => "post" do
      assert_select "input#applic_job", :name => "applic[job]"
      assert_select "input#applic_user", :name => "applic[user]"
      assert_select "textarea#applic_message", :name => "applic[message]"
      assert_select "input#applic_resume_id", :name => "applic[resume_id]"
      assert_select "input#applic_transcript_id", :name => "applic[transcript_id]"
    end
  end
end
