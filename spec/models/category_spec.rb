require 'spec_helper'

describe Category do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :job => Job.find_or_create_by_name(:id => 1)
    }
  end

  #
  # Validation
  #
  
  it "should create a new instance given valid attributes" do
    Category.create!(@valid_attributes)
  end
end
