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
      :credit => false,
	  :department => 1
    }
  end
  
  #
  # Validation
  #

  it "should create a new instance given valid attributes" do
    job = Job.create(@valid_attributes)
	job.sponsorships.stub!(size).and_return(1)
	job.save.should be_true
  end
  
end
