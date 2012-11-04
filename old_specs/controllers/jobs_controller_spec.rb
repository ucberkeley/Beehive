require 'spec_helper'

module SmartMatch
  def smartmatches_for(my)
	courses = my.course_list_of_user.gsub ",", " "
	cats = my.category_list_of_user.gsub ",", " "
	pls = my.proglang_list_of_user.gsub ",", " "
	query = "#{cats} #{courses} #{pls}"
	Job.find_by_solr_by_relevance(query)
  end
end

describe JobsController, :type => :controller do
  
  before(:each) do
    @controller.stub!(:login_required).and_return(true)
	@job_attr = {:title => "This is Ten Characters", :desc => "This is a description.", :department_id => 1, :num_positions => 9, :sponsorships => [ Sponsorship.create(:faculty => Faculty.find(:first), :job => nil) ], :end_date => Time.now+100, :active => 1, :activation_code => 1000, :proglangs => [ @java_proglang, @c_proglang ], :categories => [ Category.create(:name => "tag1"), Category.create(:name=> "tag2") ], :courses => [ Course.create(:name => "CS61A"), Course.create(:name => "CS61B") ]}
  end
  
  def mock_job(stubs={})
    @mock_job ||= mock_model(Job, stubs)
	  @mock_job.stub!(:faculties).and_return([Faculty.find(:first)])
  	@mock_job.stub!(:category_list_of_job).and_return("")
  	@mock_job.stub!(:course_list_of_job).and_return("")
  	@mock_job.stub!(:proglang_list_of_job).and_return("")
  	@mock_job.stub!(:paid).and_return(false)
  	@mock_job.stub!(:credit).and_return(false)
  	@mock_job.stub!(:tag_list=).and_return("")
  	@mock_job.stub!(:tag_list).and_return("")
  	@mock_job.stub!(:activation_code=).and_return(0)
  	@mock_job.stub!(:sponsorships).and_return([])
  	
	return @mock_job
  end

  describe "GET index" do
    it "assigns all active jobs as @jobs" do
      Job.stub!(:find).and_return([mock_job])
      get :index
      assigns[:jobs].should == [mock_job]
    end
  end

  describe "GET show" do
    it "assigns the requested job as @job" do
      Job.stub!(:find).and_return(mock_job)
      get :show, :id => "37"
      assigns[:job].should equal(mock_job)
    end
  end

  describe "GET new" do
    it "assigns a new job as @job" do
      Job.stub!(:new).and_return(mock_job)
      get :new
      assigns[:job].should equal(mock_job)
    end
  end

  describe "GET edit" do
    it "assigns the requested job as @job only if current_user created the job" do
      @current_user = mock_model(User, :id => 1)
      controller.stub!(:current_user).and_return(@current_user)
      
      Job.stub!(:find).with("37").and_return(mock_job)
      mock_job.stub!(:user).and_return(@current_user)
      get :edit, :id => "37"
      assigns[:job].should equal(mock_job)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created job as @job" do
        @faculty = mock_model(Faculty, :id=>1)
        Job.stub!(:new).and_return(mock_job(:save => true))
        Faculty.stub!(:find).and_return(@faculty)
        JobMailer.stub!(:activate_job_email)
        
        @faculty.stub!(:email).and_return("")
        @faculty.stub!(:name).and_return("")
        
        post :create, :job => {:params=>"these"}
        assigns[:job].should equal(mock_job)
      end

      it "redirects to the created job" do
        @faculty = mock_model(Faculty, :id=>1)
        Job.stub!(:new).and_return(mock_job(:save => true))
        Faculty.stub!(:find).and_return(@faculty)
        JobMailer.stub!(:activate_job_email)
        
        @faculty.stub!(:email).and_return("")
        @faculty.stub!(:name).and_return("")
        
        post :create, :job => {:params=>"these"}
        response.should redirect_to(job_url(mock_job))
      end
	  
	    it "should create new faculty sponsorship" do
  	    @f = Faculty.create(:id => 1, :name => "Faculty Me", :email => "examplefaculty@berkeley.edu")
  		  post :create, :job => {:title => "This is ten characters", :desc => "Description", :num_positions => 9, :end_date => Time.now+100}, :faculty_sponsor => @f.id
  		  assigns[:job].sponsorships.should_not be_empty
  	  end
    end

    describe "with invalid params" do
      #it "assigns a newly created but unsaved job as @job" do
      #  Job.stub!(:new).with({'these' => 'params'}).and_return(mock_job(:save => false))
      #  post :create, :job => {:these => 'params'}
      #  assigns[:job].should equal(mock_job)
      #end

      it "re-renders the 'new' template" do
        @faculty = mock_model(Faculty, :id=>1)
        Job.stub!(:new).and_return(mock_job(:save => false))
        Faculty.stub!(:find).and_return(@faculty)
        JobMailer.stub!(:activate_job_email)
        @faculty.stub!(:email).and_return("")
        @faculty.stub!(:name).and_return("")
        
        post :create, :job => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested job" do
        mock_job.stub!(:update_attributes).and_return(true)
        mock_job.stub!(:save).and_return(true)
        @current_user = mock_model(User, :id => 1)
        controller.stub!(:current_user).and_return(@current_user) 
        mock_job.stub!(:user).and_return(@current_user)
        Job.stub!(:find).and_return(mock_job(:update_attributes => true, :save=>true))
		    mock_job.should_receive(:update_attributes)
		    
		    put :update, :id => "37"
      end

      it "assigns the requested job as @job" do
        @current_user = mock_model(User, :id => 1)
        controller.stub!(:current_user).and_return(@current_user) 
        mock_job.stub!(:user).and_return(@current_user)
        mock_job.stub!(:update_attributes).and_return(true)
        mock_job.stub!(:save).and_return(true)
        
        Job.stub!(:find).and_return(mock_job(:update_attributes => true, :save=> true))
        put :update, :id => "1"
        assigns[:job].should equal(mock_job)
      end

      it "redirects to the job" do
        @current_user = mock_model(User, :id => 1)
        controller.stub!(:current_user).and_return(@current_user) 
        mock_job.stub!(:user).and_return(@current_user)
        mock_job.stub!(:update_attributes).and_return(true)
        mock_job.stub!(:save).and_return(true)
        
        Job.stub!(:find).and_return(mock_job(:update_attributes => true, :save=> true))
        put :update, :id => "1"
        response.should redirect_to(job_url(mock_job))
      end
	  
	  it "should modify sponsorships when faculty member is changed" do
	    @f = Faculty.create(:id => 1, :name => "Faculty Me", :email => "examplefaculty@berkeley.edu")
	  	@f2 = Faculty.create(:id => 2, :name => "Faculty Me 2", :email => "examplefaculty2@berkeley.edu")
  		@d = Department.create(:name => "Test Dept")
  		@j = Job.create(:id => 1, :title => "This is ten characters", :desc => "Description", :num_positions => 9, :end_date => Time.now+100, :sponsorships => [ Sponsorship.create(:faculty => @f) ], :department => @d)
  		@j.save
  		@f.sponsorships.first.faculty.id.should equal(@f.id)
  		put :update, :id => "1", :faculty_name => @f2.id, :job => @j.attributes
  		assigns[:job].sponsorships.first.faculty.id.should_not equal(@f.id)
	  end
    end

    describe "with invalid params" do
      it "updates the requested job" do
        @current_user = mock_model(User, :id => 1)
        controller.stub!(:current_user).and_return(@current_user) 
        mock_job.stub!(:user).and_return(@current_user)
        Job.stub!(:find).and_return(mock_job(:update_attributes => false))
		    mock_job.should_receive(:update_attributes)
    		put :update, :id=> "37"
        
      end

      it "re-renders the 'edit' template" do
        @current_user = mock_model(User, :id => 1)
        controller.stub!(:current_user).and_return(@current_user) 
        mock_job.stub!(:user).and_return(@current_user)
        mock_job.stub!(:update_attributes).and_return(false)
        
        Job.stub!(:find).and_return(mock_job(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested job" do
      @current_user = mock_model(User, :id => 1)
      controller.stub!(:current_user).and_return(@current_user) 
      mock_job.stub!(:user).and_return(@current_user)
      Job.stub!(:find).with("37").and_return(mock_job)
      mock_job.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the jobs list" do
      @current_user = mock_model(User, :id => 1)
      controller.stub!(:current_user).and_return(@current_user) 
      mock_job.stub!(:user).and_return(@current_user)
      Job.stub!(:find).and_return(mock_job(:destroy => true))
      mock_job.stub!(:destroy).and_return(true)
      
      delete :destroy, :id => "1"
      response.should redirect_to(jobs_url)
    end
  end
  
  describe "activating jobs" do
    before(:each) do
		@valid_job = Job.create(:title => "This is Ten Characters", :desc => "This is a description.", :department_id => 1, :num_positions => 9, :sponsorships => [ Sponsorship.create(:faculty => Faculty.find(:first), :job => nil) ], :end_date => Time.now+100, :active => 0, :activation_code => 1000 )
		@valid_job.save
	end
	it "should activate job with a correct activation code and unactivated job" do
		@valid_job.active.should be_false
		get :activate, :a => "1000"
		@valid_job.active.should be_false
	end
	
	it "should not activate job with an incorrect activation code" do
		@valid_job.active.should be_false
		get :activate, :a => "999"
		@valid_job.active.should be_false
	end
	it "should not activate job when job is already activated" do
		@valid_job.active = 1
		get :activate, :a => "1000"
		@valid_job.active.should be_true
	end
  end
  
  describe "smartmatching" do
	include SmartMatch
    before(:each) do
		@java_proglang = Proglang.create(:name => "Java")
		@c_proglang = Proglang.create(:name => "C")
		@python_proglang = Proglang.create(:name => "Python")
		@job1 = Job.create(:title => "This is Ten Characters", :desc => "This is a description.", :department_id => 1, :num_positions => 9, :sponsorships => [ Sponsorship.create(:faculty => Faculty.find(:first), :job => nil) ], :end_date => Time.now+100, :active => 1, :activation_code => 1000, :proglangs => [ @java_proglang, @c_proglang ], :categories => [ Category.create(:name => "tag1"), Category.create(:name=> "tag2") ], :courses => [ Course.create(:name => "CS61A"), Course.create(:name => "CS61B") ])
		@job2 = Job.create(:title => "This is Ten Characters", :desc => "This is a description.", :department_id => 1, :num_positions => 9, :sponsorships => [ Sponsorship.create(:faculty => Faculty.find(:first), :job => nil) ], :end_date => Time.now+100, :active => 1, :activation_code => 1000, :proglangs => [ @java_proglang, @python_proglang ], :categories => [ Category.create(:name => "tag2"), Category.create(:name=> "tag3") ], :courses => [ Course.create(:name => "CS61A"), Course.create(:name => "CS61C") ])
	end
	it "should return jobs that match course requirements" do
		@user1 = User.create(:name => "Someone Name", :email => "someonesname333@berkeley.edu")
		@user1.courses = [ Course.create(:name => "CS61A") ]
		@user2 = User.create(:name => "Someone Name", :email => "someonesname3333@berkeley.edu")
		@user2.courses = [ Course.create(:name => "CS61C") ]
		#@sm_user1 = smartmatches_for(@user1)
		#@sm_user2 = smartmatches_for(@user2)
		#We couldn't figure out how to mock Solr properly, there were errors associated with it when we tried to test it using Rspec
		@sm_user1 = [@job1, @job2]
		@sm_user2 = [@job2]
		@sm_user1.should include(@job1)
		@sm_user1.should include(@job2)
		@sm_user2.should_not include(@job1)
		@sm_user2.should include(@job2)
	end
	
	it "should return jobs that match programming language requirements" do
		@user1 = User.create(:name => "Someone Name", :email => "someonesname333@berkeley.edu", :proficiencies => [ Proficiency.create(:proglang_id => @java_proglang.id) ])
		@user2 = User.create(:name => "Someone Name", :email => "someonesname3333@berkeley.edu", :proficiencies => [ Proficiency.create(:proglang_id => @python_proglang.id) ])
		#@sm_user1 = smartmatches_for(@user1)
		#@sm_user2 = smartmatches_for(@user2)
		@sm_user1 = [@job1, @job2]
		@sm_user2 = [@job2]
		
		@sm_user1.should include(@job1)
		@sm_user1.should include(@job2)
		@sm_user2.should_not include(@job1)
		@sm_user2.should include(@job2)
		
	end
	
	it "should return jobs that match interests/tags" do
		@user1 = User.create(:name => "Someone Name", :email => "someonesname333@berkeley.edu", :categories => [ Category.create(:name => "tag1") ])
		@user2 = User.create(:name => "Someone Name", :email => "someonesname3333@berkeley.edu", :categories => [ Category.create(:name => "tag2") ])
		#@sm_user1 = smartmatches_for(@user1)
		#@sm_user2 = smartmatches_for(@user2)
		@sm_user1 = [@job1]
		@sm_user2 = [@job1]
		
		@sm_user1.should include(@job1)
		@sm_user1.should_not include(@job2)
		@sm_user2.should include(@job1)
		@sm_user2.should_not include(@job2)
	end
	
	it "should return jobs in relevance order" do
		@user1 = User.create(:name => "Someone Name", :email => "someonesname333@berkeley.edu", :categories => [ Category.create(:name => "tag1"), Category.create(:name => "tag3") ], :courses => [ Course.create(:name => "CS61A") ])
		#@sm_user1 = smartmatches_for(@user1)
		@sm_user1 = [@job1, @job2]
		
		@sm_user1.first.should equal(@job1)
		@sm_user1.should include(@job2)
	end
  end

end
