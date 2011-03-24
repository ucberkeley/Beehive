require 'spec_helper'

describe "users/index.html.erb" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :login => "Login",
        :email => "Email",
        :persistence_token => "Persistence Token",
        :single_access_token => "Single Access Token",
        :perishable_token => "Perishable Token"
      ),
      stub_model(User,
        :login => "Login",
        :email => "Email",
        :persistence_token => "Persistence Token",
        :single_access_token => "Single Access Token",
        :perishable_token => "Perishable Token"
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Login".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Persistence Token".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Single Access Token".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Perishable Token".to_s, :count => 2
  end
end
