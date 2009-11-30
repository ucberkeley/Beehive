require 'spec_helper'

describe JobsController do
  
  before(:each) do
    @controller.stub!(:login_required).and_return(true)
  end
  
  def mock_job(stubs={})
    @mock_job ||= mock_model(Job, stubs)
  end

  describe "GET index" do
    it "assigns all active jobs as @jobs" do
      Job.stub!(:find).with(:all).and_return([mock_job])
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
        Job.stub!(:new).with({'these' => 'params'}).and_return(mock_job(:save => true))
        post :create, :job => {:these => 'params'}
        assigns[:job].should equal(mock_job)
      end

      it "redirects to the created job" do
        Job.stub!(:new).with({'these' => 'params'}).and_return(mock_job(:save => true))
        post :create, :job => {:these => 'params'}
        response.should redirect_to(job_url(mock_job))
      end
	  
	  it "should create new faculty sponsorship"
	  
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job as @job" do
        Job.stub!(:new).with({'these' => 'params'}).and_return(mock_job(:save => false))
        post :create, :job => {:these => 'params'}
        assigns[:job].should equal(mock_job)
      end

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
        mock_job.should_receive(:update_attributes).with({'these' => 'params'})
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
        mock_job.should_receive(:update_attributes).with({'these' => 'params'})
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
	it "should return all active jobs if there are no search parameters"
	it "should return jobs that matches keyword query"
	it "should return jobs that match department query"
	it "should return jobs that match faculty query"
	it "should return jobs that match paid query"
	it "should return jobs that match credit query"
  end
  
  describe "activating jobs" do
	it "should activate job with a correct activation code and unactivated job"
	it "should not activate job with an incorrect activation code"
	it "should not activate job when job is already activated"
  end

end
