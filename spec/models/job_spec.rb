require 'rails_helper'
require 'spec_helper'

RSpec.describe Job, type: :model do
  it "should have title" do
  	FactoryGirl.build(:job, title:nil).should_not be_valid
  end

  it "should have project type" do
  	FactoryGirl.build(:job, title:nil).should_not be_valid
  end

  it "should have department" do
  	FactoryGirl.build(:job, department:nil).should_not be_valid
  end

  it "should have description" do
  	FactoryGirl.build(:job, desc:nil).should_not be_valid
  end

  it "should have earliest date" do
  	FactoryGirl.build(:job, earliest_start_date:nil).should_not be_valid
  end

  it "should have latest start date" do
  	FactoryGirl.build(:job, latest_start_date:nil).should_not be_valid
  end

  it "should have end date" do
  	FactoryGirl.build(:job, end_date:nil).should_not be_valid
  end

  it "earliest date must be before latest start date" do
  	FactoryGirl.build(:latest_lessthan_earliest).should_not be_valid
  end

  it "latest start date must be before end date" do
  	FactoryGirl.build(:end_lessthan_latest).should_not be_valid
  end

  it "factory default entry should be valid" do
  	FactoryGirl.create(:job).should be_valid
  end

end
