require 'spec_helper'

describe "users/edit.html.erb" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :login => "MyString",
      :email => "MyString",
      :persistence_token => "MyString",
      :single_access_token => "MyString",
      :perishable_token => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path(@user), :method => "post" do
      assert_select "input#user_login", :name => "user[login]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_persistence_token", :name => "user[persistence_token]"
      assert_select "input#user_single_access_token", :name => "user[single_access_token]"
      assert_select "input#user_perishable_token", :name => "user[perishable_token]"
    end
  end
end
