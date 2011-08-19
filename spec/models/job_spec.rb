require 'spec_helper'

describe Job do
  before(:each) do
    @controller = mock('JobsController')
    @controller.stub!(:login_required).and_return(true)
    @valid_attributes = {
      :user_id => 1,
      :title => "value for title",
      :desc => "value for desc",
      :category_id => 1,
      :end_date => Time.now + 5.hours,
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
            j.errors[:title].should be_empty
          end.should change(Job, :count).by(1)
        end
      end
    end
	
  
    describe 'disallows title of length < 10 characters' do
      ['Test', '', 'title', 'lol', 'fail'].each do |title_str|
        it "'#{title_str}'" do
          lambda do
            j = create_job(:title => title_str)
            j.errors[:title].should_not be_empty
          end.should_not change(Job, :count)
        end
      end
    end
  end
  
  describe "end_date of the job" do
    describe 'allows end_date during or after right now' do
      [Time.now, Time.now + 1.second, Time.now + 1.day, Time.now + 1.year].each do |e|
        it "'#{e}'" do
          lambda do
            j = create_job(:end_date => e)
            j.errors[:end_date].should be_empty
          end.should change(Job, :count).by(1)
        end
      end
    end
	
  
    describe 'disallows end_date before (right now - 1.hour)' do
      [Time.now - 1.day, Time.now - 1.month, Time.now - 1.year].each do |e|
        it "'#{e}'" do
          lambda do
            j = create_job(:end_date => e)
            j.errors[:end_date].should_not be_empty
          end.should_not change(Job, :count)
        end
      end
    end
  end

  describe "latest start date of the job" do
    describe "allows latest start date before end date" do
      [Time.now - 5.seconds, Time.now - 1.day, Time.now - 1.month,
        Time.now - 1.year].each do |sd|
        
        it "'#{sd}'" do
          lambda do
            j = create_job(:latest_start_date => sd)
            j.errors[:latest_start_date].should_not be_empty
          end
        end
      end
    end

    describe "disallows latest start date after end date" do
      [Time.now + 6.hours, Time.now + 1.day, Time.now + 1.month,
        Time.now + 1.year].each do |sd|
        
        it "'#{sd}'" do
          lambda do
            j = create_job(:latest_start_date => sd)
            j.errors[:latest_start_date].should be_empty
          end
        end
      end
    end

    describe "disallows earliest start date after latest start date" do
      lsdate = Time.now + 1.month
      [lsdate + 1.month, lsdate + 1.year].each do |sd|
        
        it "'#{sd}'" do
          lambda do
            j = create_job(:earliest_start_date => sd, :latest_start_date => lsdate,
              :open_ended_end_date => false)
            j.errors[:latest_start_date].should_not be_empty
          end
        end
      end

    end
  end
  
  describe "job description" do
    it "should not be blank" do
      lambda do
        j = create_job(:desc => '')
        j.errors[:desc].should_not be_empty
      end.should_not change(Job, :count)
    end
  end

  
  protected
  def create_job(options = {})
    record = Job.new({ :title => 'SampleJobTitle', :desc => 'descriptiongoeshere', 
		:end_date => Time.now + 5.hours, :num_positions => 0, 
				:department => Department.find_or_create_by_name(:name => "EECS") }.merge(options))
	record.sponsorships = record.sponsorships << Sponsorship.create({:faculty_id => 1, :job_id => 1})
    record.save
    record
  end
  
end
