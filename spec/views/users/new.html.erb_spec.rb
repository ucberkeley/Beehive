require 'spec_helper'

describe "users/new.html.erb" do
  before(:each) do
    assign(:user, stub_model(User,
      :login => "MyString",
      :email => "MyString",
      :persistence_token => "MyString",
      :single_access_token => "MyString",
      :perishable_token => "MyString"
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_login", :name => "user[login]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_persistence_token", :name => "user[persistence_token]"
      assert_select "input#user_single_access_token", :name => "user[single_access_token]"
      assert_select "input#user_perishable_token", :name => "user[perishable_token]"
    end
  end
end
