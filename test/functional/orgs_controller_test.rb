require 'test_helper'

class OrgsControllerTest < ActionController::TestCase
  setup do
    @org = orgs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orgs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create org" do
    assert_difference('Org.count') do
      post :create, org: { desc: @org.desc, name: @org.name }
    end

    assert_redirected_to org_path(assigns(:org))
  end

  test "should show org" do
    get :show, id: @org
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @org
    assert_response :success
  end

  test "should update org" do
    put :update, id: @org, org: { desc: @org.desc, name: @org.name }
    assert_redirected_to org_path(assigns(:org))
  end

  test "should destroy org" do
    assert_difference('Org.count', -1) do
      delete :destroy, id: @org
    end

    assert_redirected_to orgs_path
  end
end
