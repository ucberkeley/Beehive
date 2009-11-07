require 'spec_helper'

describe Picture do
  before(:each) do
    @valid_attributes = {
      :url => "value for url",
      :user_id => 1,
      :job_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Picture.create!(@valid_attributes)
  end
end
