require 'spec_helper'

describe Job do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => "value for title",
      :desc => "value for desc",
      :category_id => 1,
      :exp_date => Time.now,
      :num_positions => 1,
      :paid => false,
      :credit => false
    }
  end

  it "should create a new instance given valid attributes" do
    Job.create!(@valid_attributes)
  end
end
