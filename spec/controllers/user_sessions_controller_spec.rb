require 'spec_helper'

describe UserSessionsController do
  before(:each) do
    @mock_user ||= mock_model(User)
  end

  context 'when not authenticated via CAS' do
    it 'should redirect to CAS' do
      get :destroy # something that needs a user session
      response.should redirect_to CASClient::Frameworks::Rails::Filter.login_url(controller)
    end
  end # not auth via CAS

  context 'when authenticated via CAS' do
    before(:each) { SpecHelperMethods.stub_cas_ok }

    context 'when no user exists' do
        before(:each) { controller.stub(:current_user).and_return(nil) }

        it 'should redirect to new user page' do
          get :destroy
          response.should redirect_to new_user_path
        end
    end # no user

    context 'when user already exists' do
        before(:each) { controller.stub(:current_user).and_return(@mock_user) }

        it 'should log in if a user exists' do
          get :destroy
          response.should be_success
        end
    end # existing user
  end # auth via CAS

end
