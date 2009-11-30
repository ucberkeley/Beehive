require 'spec_helper'

describe Job do
  before(:each) do
	@controller.stub!(:login_required).and_return(true)
    @valid_attributes = {
      :user_id => 1,
      :title => "value for title",
      :desc => "value for desc",
      :category_id => 1,
      :exp_date => Time.now + 5.hours,
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
    job = Job.new(@valid_attributes)
	job.errors.should be_empty
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
  
  describe "exp_date of the job" do
	describe 'allows exp_date during or after right now' do
		[Time.now, Time.now + 1.second, Time.now + 1.day, Time.now + 1.year].each do |e|
			it "'#{e}'" do
				lambda do
					j = create_job(:exp_date => e)
					j.errors.on(:exp_date).should be_nil
				end.should change(Job, :count).by(1)
			end
		end
	end
	
  
    describe 'disallows exp_date before (right now - 1.hour)' do
		[Time.now - 1.day, Time.now - 1.month, Time.now - 1.year].each do |e|
			it "'#{e}'" do
				lambda do
					j = create_job(:exp_date => e)
					j.errors.on(:exp_date).should_not be_nil
				end.should_not change(Job, :count)
			end
		end
	end
  end
  
  describe "job description" do
	it "should not be blank" do
		lambda do
			j = create_job(:desc => '')
			j.errors.on(:desc).should_not be_nil
		end.should_not change(Job, :count)
	end
  end

  
  protected
  def create_job(options = {})
    record = Job.new({ :title => 'SampleJobTitle', :desc => 'descriptiongoeshere', 
		:exp_date => Time.now + 5.hours, :num_positions => 0, 
				:department => Department.find_or_create_by_name(:name => "EECS") }.merge(options))
	record.sponsorships = record.sponsorships << Sponsorship.create({:faculty_id => 1, :job_id => 1})
    record.save
    record
  end
  
end
