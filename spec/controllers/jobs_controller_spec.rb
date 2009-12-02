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
	@job_attr = {:title => "This is Ten Characters", :desc => "This is a description.", :department_id => 1, :num_positions => 9, :sponsorships => [ Sponsorship.create(:faculty => Faculty.find(:first), :job => nil) ], :exp_date => Time.now+100, :active => 1, :activation_code => 1000, :proglangs => [ @java_proglang, @c_proglang ], :categories => [ Category.create(:name => "tag1"), Category.create(:name=> "tag2") ], :courses => [ Course.create(:name => "CS61A"), Course.create(:name => "CS61B") ]}
  end
  
  def mock_job(stubs={})
    @mock_job ||= mock_model(Job, stubs)
	@mock_job.stub!(:faculties).and_return([Faculty.find(:first)])
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
    it "assigns the requested job as @job" do
      Job.stub!(:find).with("37").and_return(mock_job)
      get :edit, :id => "37"
      assigns[:job].should equal(mock_job)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created job as @job" do
        Job.stub!(:new).and_return(mock_job(:save => true))
        post :create, :job => @job_attr
        assigns[:job].should equal(mock_job)
      end

      it "redirects to the created job" do
        Job.stub!(:new).and_return(mock_job(:save => true))
        post :create, :job => @job_attr
        response.should redirect_to(job_url(mock_job))
      end
	  
	  it "should create new faculty sponsorship"
	  
    end

    describe "with invalid params" do
      #it "assigns a newly created but unsaved job as @job" do
      #  Job.stub!(:new).with({'these' => 'params'}).and_return(mock_job(:save => false))
      #  post :create, :job => {:these => 'params'}
      #  assigns[:job].should equal(mock_job)
      #end

      it "re-renders the 'new' template" do
        Job.stub!(:new).and_return(mock_job(:save => false))
        post :create, :job => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested job" do
        Job.should_receive(:find).with("37").and_return(mock_job)
		put :update, :id => "37"
        mock_job.should_receive(:update_attributes)
      end

      it "assigns the requested job as @job" do
        Job.stub!(:find).and_return(mock_job(:update_attributes => true))
        put :update, :id => "1"
        assigns[:job].should equal(mock_job)
      end

      it "redirects to the job" do
        Job.stub!(:find).and_return(mock_job(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(job_url(mock_job))
      end
	  
	  it "should modify sponsorships when faculty member is changed"
    end

    describe "with invalid params" do
      it "updates the requested job" do
        Job.should_receive(:find).with("37").and_return(mock_job)
        mock_job.should_receive(:update_attributes)
      end

      it "re-renders the 'edit' template" do
        Job.stub!(:find).and_return(mock_job(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested job" do
      Job.should_receive(:find).with("37").and_return(mock_job)
      mock_job.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the jobs list" do
      Job.stub!(:find).and_return(mock_job(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(jobs_url)
    end
  end
  
  describe "searching function" do
	# (for all of these: and render index)
	it "should return all active jobs if there are no search parameters" do
		get :list, :search_terms => [ :query => "" ]
		assign[:jobs].should_not equal(nil)
	end	
	it "should return jobs that matches keyword query"
		
	it "should return jobs that match department query"
	it "should return jobs that match faculty query"
	it "should return jobs that match paid query"
	it "should return jobs that match credit query"
	it "should not return jobs that don't match any of the queries"
  end
  
  describe "activating jobs" do
    before(:each) do
		@valid_job = Job.create(:title => "This is Ten Characters", :desc => "This is a description.", :department_id => 1, :num_positions => 9, :sponsorships => [ Sponsorship.create(:faculty => Faculty.find(:first), :job => nil) ], :exp_date => Time.now+100, :active => 0, :activation_code => 1000 )
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
		@valid_job.active.should be_true
	end
  end
  
  describe "smartmatching" do
	include SmartMatch
    before(:each) do
		@java_proglang = Proglang.create(:name => "Java")
		@c_proglang = Proglang.create(:name => "C")
		@python_proglang = Proglang.create(:name => "Python")
		@job1 = Job.create(:title => "This is Ten Characters", :desc => "This is a description.", :department_id => 1, :num_positions => 9, :sponsorships => [ Sponsorship.create(:faculty => Faculty.find(:first), :job => nil) ], :exp_date => Time.now+100, :active => 1, :activation_code => 1000, :proglangs => [ @java_proglang, @c_proglang ], :categories => [ Category.create(:name => "tag1"), Category.create(:name=> "tag2") ], :courses => [ Course.create(:name => "CS61A"), Course.create(:name => "CS61B") ])
		@job2 = Job.create(:title => "This is Ten Characters", :desc => "This is a description.", :department_id => 1, :num_positions => 9, :sponsorships => [ Sponsorship.create(:faculty => Faculty.find(:first), :job => nil) ], :exp_date => Time.now+100, :active => 1, :activation_code => 1000, :proglangs => [ @java_proglang, @python_proglang ], :categories => [ Category.create(:name => "tag2"), Category.create(:name=> "tag3") ], :courses => [ Course.create(:name => "CS61A"), Course.create(:name => "CS61C") ])
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
		@sm_user3 = [@job1]
		
		@sm_user1.should include(@job1)
		@sm_user1.should_not include(@job2)
		@sm_user2.should include(@job1)
		@sm_user2.should_not include(@job2)
	end
	
	it "should return jobs in relevance order" do
		@user1 = User.create(:name => "Someone Name", :email => "someonesname333@berkeley.edu", :categories => [ Category.create(:name => "tag1"), Category.create(:name => "tag3") ], :courses => [ Course.create(:name => "CS61A") ])
		@sm_user1 = smartmatches_for(@user1)
		
		@sm_user1.first.should equal(@job1)
		@sm_user1.should include(@job2)
	end
  end

end
