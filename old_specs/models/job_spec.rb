require 'spec_helper'

describe Job do
  fixtures :all

  before(:each) do
    @controller = mock('JobsController')
    @controller.stub!(:login_required).and_return(true)
    @valid_attributes = {
      :title => "value for title",
      :desc => "value for desc",
      :end_date => Time.now + 5.hours,
      :num_positions => 1,
      :compensation => Job::Compensation::None,
      :active => true
    }

    @mock_sponsorship ||= stub_model(Sponsorship)
    @mock_department  ||= stub_model(Department)
    @mock_user        ||= stub_model(User)
    @mock_category    ||= stub_model(Category)
  end
  
  #
  # Validation
  #
  describe "validation:" do

    #
    # Setup
    #

    before :each do
      @valid_jobs = []
    end

    after :each do
      @valid_jobs.each {|j| j.destroy}
    end

    #
    # Specs
    #

    it "should create a new instance given valid attributes" do
      create_job.should be_valid
      job = Job.new(@valid_attributes)
      job.sponsorships << mock_model(Sponsorship)
      job.department   =  mock_model(Department)
      job.user         =  mock_model(User)
      job.categories   << mock_model(Category)
      job.valid?
      job.errors.should == {} and job.should be_valid
    end

    describe "title" do
      it "should be between 10 and 200 characters, inclusive" do
        test_range(10..200) do |n, valid|
          Job.new(:title => 'a'*n).errors_on(:title).empty?.should == valid
        end
      end
    end # title

    describe "description" do
      it "should be within 10 and 20000 characters" do
        test_range(10..20000) do |n, valid|
          Job.new(:desc => 'a'*n).errors_on(:desc).empty?.should == valid
        end
      end
    end

    describe "num positions" do
      it "should be nonnegative" do
        Job.new(:num_positions => -1).errors_on(:num_positions).should_not be_empty
        Job.new(:num_positions =>  0).errors_on(:num_positions).should     be_empty
        Job.new(:num_positions =>  2).errors_on(:num_positions).should     be_empty
      end

      it "should be optional" do
        Job.new(:num_positions => nil).errors_on(:num_positions).should be_empty
      end
    end

    describe "start dates" do
      before :each do
        @a = Time.now + 1.hour
        @b = @a + 1.day
        @c = @b + 1.week
      end

      it "should be in chronological order" do
        Job.new(:earliest_start_date => @a, :latest_start_date => @b).errors_on(:earliest_start_date).should be_empty
        Job.new(:earliest_start_date => @b, :latest_start_date => @a).errors_on(:earliest_start_date).should_not be_empty
      end

      describe "and end date" do
        it "should be in chronological order" do
          Job.new(:earliest_start_date => @a, :latest_start_date => @b, :end_date => @c).errors_on(:latest_start_date).should be_empty
          Job.new(:earliest_start_date => @b, :latest_start_date => @c, :end_date => @a).errors_on(:latest_start_date).should_not be_empty
        end
      end
    end # start dates

    describe "required attributes" do
      it "should include title, desc, department" do
        [ :title, :desc, :department ].each do |attrib|
          Job.new(attrib => nil).errors_on(attrib).should_not be_empty
        end
      end

      it "should include sponsorships" do
        pending
      end
    end # required attribs
    
  end # validations

  describe "searching" do
    
    describe "search with default options" do
      it "should return all active jobs that have not ended" do
        results = Job.find_jobs
        excluded = [jobs(:raid), jobs(:inactive), jobs(:closed)]
        verify_exclusion results, excluded
      end
    end

    describe "search with a query" do
      
      it "should match title" do
        results = Job.find_jobs "SEJITS"
        expected = [jobs(:sejits)]
        verify_match results, expected
        
        results = Job.find_jobs "bridge"
        expected = [jobs(:bridges)]
        verify_match results, expected
        
        results = Job.find_jobs "Console Log Mining"
        expected = [jobs(:console)]
        verify_match results, expected
        
        results = Job.find_jobs "Log Mining"
        expected = [jobs(:console)]
        verify_match results, expected
        
        results = Job.find_jobs "advanced"
        expected = [jobs(:bridges), jobs(:airplanes)]
        verify_match results, expected
      end
      
      it "should match description" do
        results = Job.find_jobs("scale")
        expected = [jobs(:scads), jobs(:cloud)]
        verify_match results, expected
        
        results = Job.find_jobs("facebook")
        expected = [jobs(:scads)]
        verify_match results, expected
        
        results = Job.find_jobs("test app")
        expected = [jobs(:cloud)]
        verify_match results, expected
        
        results = Job.find_jobs("modern sml techniques")
        expected = [jobs(:awe)]
        verify_match results, expected
        
        results = Job.find_jobs("performance")
        expected = [jobs(:awe), jobs(:scads), jobs(:cloud), jobs(:sejits)]
        verify_match results, expected
      end
            
      it "should match faculty" do
        results = Job.find_jobs "fox"
        excluded = [jobs(:brain), jobs(:airplanes), jobs(:raid), jobs(:inactive), jobs(:closed)]
        verify_exclusion results, excluded
                                   
        results = Job.find_jobs "joseph"
        expected = [jobs(:cloud), jobs(:console), jobs(:bridges)]
        verify_match results, expected
        
        results = Job.find_jobs "anthony"
        expected = [jobs(:cloud)]
        verify_match results, expected
        
        results = Job.find_jobs "katz"
        expected = [jobs(:cloud)]
        verify_match results, expected
        
        results = Job.find_jobs "Hellerstein"
        expected = [jobs(:console), jobs(:bridges)]
        verify_match results, expected
      end
      
      it "should match department" do
        results = Job.find_jobs "EECS"
        excluded = [jobs(:brain), jobs(:bridges), jobs(:airplanes), jobs(:raid), jobs(:inactive), jobs(:closed)]
        verify_exclusion results, excluded
        
        results = Job.find_jobs "Cognitive Science"
        expected = [jobs(:brain)]
        verify_match results, expected
        
        results = Job.find_jobs "Cognitive"
        expected = [jobs(:brain)]
        verify_match results, expected
        
        results = Job.find_jobs "Engineering"
        expected = [jobs(:bridges), jobs(:airplanes)]
        verify_match results, expected
      end
      
      it "should match categories" do
        results = Job.find_jobs "Artificial Intelligence"
        expected = [jobs(:scads), jobs(:console), jobs(:awe), jobs(:brain)]
        verify_match results, expected
        
        results = Job.find_jobs "Computer Vision"
        expected = [jobs(:bridges)]
        verify_match results, expected
        
        results = Job.find_jobs "Computer"
        expected = [jobs(:bridges), jobs(:airplanes)]
        verify_match results, expected
        
        results = Job.find_jobs "Operating Systems"
        expected = [jobs(:console)]
        verify_match results, expected
        
        results = Job.find_jobs "Operating"
        expected = [jobs(:console)]
        verify_match results, expected
      end
      
      it "should match courses" do
        results = Job.find_jobs "CS161"
        expected = [jobs(:awe)]
        verify_match results, expected
        
        results = Job.find_jobs "CS188"
        expected = [jobs(:scads), jobs(:airplanes), jobs(:brain)]
        verify_match results, expected
        
        results = Job.find_jobs "CS61B"
        expected = [jobs(:awe), jobs(:sejits)]
        verify_match results, expected
        
        # results = Job.find_jobs "Data Structures"
        # expected = [jobs(:awe), jobs(:sejits)]
        # verify_match results, expected
      end
      
      it "should match programming languages" do
        results = Job.find_jobs "Java"
        expected = [jobs(:scads)]
        verify_match results, expected
        
        results = Job.find_jobs "Visual Basic"
        expected = [jobs(:awe)]
        verify_match results, expected
        
        results = Job.find_jobs "Visual"
        expected = [jobs(:awe)]
        verify_match results, expected
      end
              
      it "should match partial words" do
        results = Job.find_jobs "SEJIT"
        expected = [jobs(:sejits)]
        verify_match results, expected
        
        results = Job.find_jobs "eval"
        expected = [jobs(:awe), jobs(:cloud)]
        verify_match results, expected
        
        results = Job.find_jobs("faceboo")
        expected = [jobs(:scads)]
        verify_match results, expected
        
        results = Job.find_jobs("modern sml technique")
        expected = [jobs(:awe)]
        verify_match results, expected
        
        results = Job.find_jobs("app")
        expected = [jobs(:sejits), jobs(:scads), jobs(:cloud), jobs(:console), jobs(:awe)]
        verify_match results, expected
        
        results = Job.find_jobs "Cognitive Scienc"
        expected = [jobs(:brain)]
        verify_match results, expected
        
        # results = Job.find_jobs "Operatin"
        # expected = [jobs(:console)]
        # verify_match results, expected
#         
        # results = Job.find_jobs "Operating System"
        # expected = [jobs(:console)]
        # verify_match results, expected
#         
        # results = Job.find_jobs "Data Structure"
        # expected = [jobs(:awe), jobs(:sejits)]
        # verify_match results, expected
#         
        # results = Job.find_jobs "Visual Bas"
        # expected = [jobs(:awe)]
        # verify_match results, expected
      end
      
      it "should be case insensitive" do
        results1 = Job.find_jobs "sejits"
        results2 = Job.find_jobs "sEJitS"
        results3 = Job.find_jobs "SEJITS"
        expected = [jobs(:sejits)]
        verify_match results1, expected
        verify_match results2, expected
        verify_match results3, expected
        
        results = Job.find_jobs "rad lab"
        expected = [jobs(:cloud)]
        verify_match results, expected
        
        results = Job.find_jobs "eecs"
        excluded = [jobs(:brain), jobs(:bridges), jobs(:airplanes), jobs(:raid), jobs(:inactive), jobs(:closed)]
        verify_exclusion results, excluded
      end
      
      it "should match strange characters" do
        results = Job.find_jobs "just-in-time"
        expected = [jobs(:sejits)]
        verify_match results, expected
        
        results = Job.find_jobs "three-winged"
        expected = [jobs(:airplanes)]
        verify_match results, expected
        
        results = Job.find_jobs "i.e."
        expected = [jobs(:awe)]
        verify_match results, expected
        
        results = Job.find_jobs "20%"
        expected = [jobs(:awe)]
        verify_match results, expected
        
        results = Job.find_jobs "$20.00"
        expected = [jobs(:brain)]
        verify_match results, expected
        
        results = Job.find_jobs "under_score"
        expected = [jobs(:bridges)]
        verify_match results, expected
        
        results = Job.find_jobs "/geek"
        expected = [jobs(:bridges)]
        verify_match results, expected
        
        results = Job.find_jobs "http://"
        expected = [jobs(:bridges)]
        verify_match results, expected
        
        results = Job.find_jobs "\\\\test" #this actually searches "\\test"
        expected = [jobs(:bridges)]
        verify_match results, expected
      end
    end
    
    describe "search with params" do
            
      it "should respect :department" do
        params = {:department_id => Department.find_by_name('EECS').id}
        results = Job.find_jobs "", params
        excluded = [jobs(:brain), jobs(:bridges), jobs(:airplanes), jobs(:raid), jobs(:inactive), jobs(:closed)]
        verify_exclusion results, excluded
        
        params = {:department_id => Department.find_by_name('Cognitive Science').id}
        results = Job.find_jobs nil, params
        expected = [jobs(:brain)]
        verify_match results, expected
      end
      
      it "should respect :faculty_id" do
        params = {:faculty_id => 7}
        results = Job.find_jobs nil, params
        expected = [jobs(:sejits), jobs(:scads), jobs(:cloud), jobs(:console), jobs(:awe)]
        verify_match results, expected
        
        params = {:faculty_id => 11}
        results = Job.find_jobs nil, params
        expected = [jobs(:cloud)]
        verify_match results, expected
        
        params = {:faculty_id => 12}
        results = Job.find_jobs nil, params
        expected = [jobs(:cloud)]
        verify_match results, expected
        
        params = {:faculty_id => 9}
        results = Job.find_jobs nil, params
        expected = [jobs(:console), jobs(:bridges)]
        verify_match results, expected
      end
      
      it "should respect :limit" do
        params = {:limit => 3}
        results = Job.find_jobs nil, params
        results.length.should == 3
      end
      
      it "should respect :tags" do
        for job in Job.all
          job.populate_tag_list
          job.save!
        end
        
        params = {:tags => 'EECS'}
        results = Job.find_jobs nil, params
        expected = [jobs(:sejits), jobs(:scads), jobs(:cloud)]
        verify_match results, expected
        
        params = {:tags => 'credit'}
        results = Job.find_jobs nil, params
        expected = [jobs(:sejits), jobs(:cloud)]
        verify_match results, expected
        
        params = {:tags => 'Java'}
        results = Job.find_jobs nil, params
        expected = [jobs(:scads)]
        verify_match results, expected
        
        params = {:tags => 'unknown_tag'}
        results = Job.find_jobs nil, params
        expected = []
        verify_match results, expected
      end
      
      it "should respect :include_ended" do
        params = {:include_ended => false}
        results = Job.find_jobs "RAID", params
        expected = []
        verify_match results, expected
        
        params = {:include_ended => true}
        results = Job.find_jobs "RAID", params
        expected = [jobs(:raid)]
        verify_match results, expected
      end
      
      it "should respect :compensation" do
        params = {:compensation => nil}
        results = Job.find_jobs nil, params
        excluded = [jobs(:raid), jobs(:inactive), jobs(:closed)]
        verify_exclusion results, excluded
        
        params = {:compensation => Job::Compensation::Pay.to_s}
        results = Job.find_jobs nil, params
        excluded = [jobs(:awe), jobs(:airplanes), jobs(:raid), jobs(:inactive), jobs(:closed)]
        verify_exclusion results, excluded
        
        params = {:compensation => Job::Compensation::Credit.to_s}
        results = Job.find_jobs nil, params
        expected = [jobs(:sejits), jobs(:cloud), jobs(:brain), jobs(:airplanes)]
        verify_match results, expected
      end
      
      it "should respect :order" do
        params = {:limit => 3, :order => "jobs.created_at DESC"}
        results = Job.find_jobs nil, params
        results.should == [jobs(:airplanes), jobs(:bridges), jobs(:brain)]
        
        params = {:limit => 3, :order => "jobs.title ASC"}
        results = Job.find_jobs nil, params
        results.should == [jobs(:airplanes), jobs(:awe), jobs(:cloud)]
      end
      
      it "should respect :include_inactive" do
        params = {:include_inactive => true}
        results = Job.find_jobs nil, params
        excluded = [jobs(:raid), jobs(:closed)]
        verify_exclusion results, excluded
        
        params = {:include_inactive => false}
        results = Job.find_jobs nil, params
        excluded = [jobs(:raid), jobs(:inactive), jobs(:closed)]
        verify_exclusion results, excluded
      end
    end
  end # searching
  
def verify_match(actual_results, expected_results)
  unexpected_results = [jobs(:sejits), jobs(:awe), jobs(:console), jobs(:scads),
                       jobs(:cloud), jobs(:brain), jobs(:bridges), jobs(:airplanes),
                       jobs(:raid), jobs(:inactive), jobs(:closed)] - expected_results
  for result in expected_results
    actual_results.should include result
  end
  for result in unexpected_results
    actual_results.should_not include result
  end
end

def verify_exclusion(actual_results, unexpected_results)
  expected_results = [jobs(:sejits), jobs(:awe), jobs(:console), jobs(:scads),
                       jobs(:cloud), jobs(:brain), jobs(:bridges), jobs(:airplanes),
                       jobs(:raid), jobs(:inactive), jobs(:closed)] - unexpected_results
  for result in expected_results
    actual_results.should include result
  end
  for result in unexpected_results
    actual_results.should_not include result
  end
end

protected
  def create_job(attribs={})
    j = Job.new(@valid_attributes.merge(attribs))

    j.sponsorships << @mock_sponsorship
    j.department   =  @mock_department
    j.user         =  @mock_user
    j.categories   << @mock_category

    j.valid?
    j.errors.should == {} and j.should be_valid

    # wtf
    @mock_category.should_receive(:record_timestamps)
    @mock_sponsorship.should_receive(:[]=)

    j.save.should == true

    @valid_jobs << j
    yield j if block_given?
    j
  end
end

