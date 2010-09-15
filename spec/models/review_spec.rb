require 'spec_helper'

describe Review do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :body => "value for body",
      :rating => 1
    }
  end
=begin
  it "should create a new instance given valid attributes" do
    Review.create!(@valid_attributes)
  end
=end
end
