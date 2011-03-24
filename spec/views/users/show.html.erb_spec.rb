require 'spec_helper'

describe "users/show.html.erb" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :login => "Login",
      :email => "Email",
      :persistence_token => "Persistence Token",
      :single_access_token => "Single Access Token",
      :perishable_token => "Perishable Token"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Login/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Persistence Token/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Single Access Token/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Perishable Token/)
  end
end
