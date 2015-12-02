require 'rails_helper'
require 'spec_helper'

RSpec.describe JobsController, type: :controller do
	
	context 'unlogged-in user' do
		{@current_user => nil}
		{@user_session => nil}
		
		context 'user tries to access job list' do
			it 'should redirect to homepage' do
				get :index
				expect(response).to redirect_to(home_path)
			end
		end

		context 'user tries to access a specific job' do
			it 'should redirect to homepage' do
				get :show, :id => 1
				expect(response).to redirect_to(home_path)
			end
		end

		context 'user tries to edit a job' do
			it 'should redirect to homepage' do
				get :edit, :id => 1
				expect(response).to redirect_to(home_path)
			end
		end

		context 'user tries to post a job' do
			it 'should redirect to homepage' do
				get :create
				expect(response).to redirect_to(home_path)
			end
		end 

		context 'user tries to create a job' do
			it 'should redirect to homepage' do
				get :new
				expect(response).to redirect_to(home_path)
			end
		end 

		context 'user tries to delete a job' do
			it 'should redirect to homepage' do
				get :delete, :id => 1
				expect(response).to redirect_to(home_path)
			end
		end 

		context 'user tries to update a job' do
			it 'should redirect to homepage' do
				get :update, :id => 1
				expect(response).to redirect_to(home_path)
			end
		end 
	end

	context "when logged in" do
		before (:each) do 
				user = FactoryGirl.build(:user)
				Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(self)
				UserSession.new(user).save
				session[:user_id] = user.id
				@job = FactoryGirl.create(:job)
		end
		
		describe "GET show" do		
			it "get the specific job to be shown" do
				get :show, id: @job
				assigns(:job).should eq(@job)
			end

			it "renders the show view" do
				get :show, id: @job
				response.should render_template(:show)
			end
		end

	end

end
