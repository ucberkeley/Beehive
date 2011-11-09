require File.dirname(__FILE__) + '/../spec_helper'
  
describe UsersController do
  fixtures :users

  describe 'without authentication' do
    it 'requires authentication' do
      get :index
      response.should be_redirect
    end
  end

  describe 'with authentication' do
    before :each do
      disable_cas
    end

    describe 'registration' do
      pending
    end

    describe 'update' do
      before :each do; login_user users(:quentin); end

      it 'should succeed trivially' do
        put :update, :id => @current_user.id # without any params
        response.should redirect_to(edit_user_path(@current_user.id))
      end
    end
  end

end

