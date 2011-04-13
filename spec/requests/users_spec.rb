require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    it "should 404 because we've outlawed viewing all users in a list" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_path
      response.status.should be(404)
    end
  end
end
