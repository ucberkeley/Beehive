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
  
   it 'requires title' do
    lambda do
      u = Job.create(:title => nil)
      u.errors.on(:title).should_not be_nil
    end.should_not change(Job, :count)
  end
  
  it 'requires description' do
     lambda do
      u = Job.create(:desc => nil)
      u.errors.on(:desc).should_not be_nil
    end.should_not change(Job, :count)
  end
  
  it 'requires department' do
    lambda do
      u = Job.create(:department => nil)
      u.errors.on(:department).should_not be_nil
    end.should_not change(Job, :count)
  end
  
   it 'requires num_positions' do
     lambda do
      u = Job.create(:num_positions => nil)
      u.errors.on(:num_positions).should_not be_nil
    end.should_not change(Job, :count)
  end
end
