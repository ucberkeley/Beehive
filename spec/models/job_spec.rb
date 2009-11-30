require 'spec_helper'

describe Job do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => "value for title",
      :desc => "value for desc",
      :category_id => 1,
      :exp_date => Time.now - 5.hours,
      :num_positions => 1,
      :paid => false,
      :credit => false,
	  :department_id => 1
    }
  end
  
  #
  # Validation
  #

  it "should create a new instance given valid attributes" do
    job = Job.create(@valid_attributes)
	job.sponsorships.stub!(:size).and_return(1)
	puts job.errors
	job.save.should be_true
  end
  
  describe "title of the job" do
	describe 'allows title of length >= 10 characters' do
		["Awesome job. Really.", "ThisJobTEN", "Robotics research", 
		"cool stuff found here"].each do |title_str|
			it "'#{title_str}'" do
				lambda do
					j = create_job(:title => title_str)
					j.errors.on(:title).should be_nil
				end.should change(Job, :count).by(1)
			end
		end
	end
	
  
    describe 'disallows title of length < 10 characters' do
		['Test', '', 'title', 'lol', 'fail'].each do |title_str|
			it "'#{title_str}'" do
				lambda do
					j = create_job(:title => title_str)
					j.errors.on(:title).should_not be_nil
				end.should_not change(Job, :count)
			end
		end
	end
  end
  

  
  protected
  def create_job(options = {})
    record = Job.new({ :title => 'SampleJobTitle', :desc => 'descriptiongoeshere', 
		:exp_date => Time.now - 5.hours, :num_positions => 0 }.merge(options))
    record.save
    record
  end
  
end
