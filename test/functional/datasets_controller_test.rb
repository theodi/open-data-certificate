require 'test_helper'

class DatasetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "not signed_in users should get redirected to login" do
    get :new
    assert_response :redirect
  end

  test "signed_in users should get new" do
    sign_in FactoryGirl.create(:user)
    get :new
    assert_response :success
  end

  test "signed_in users should create dataset" do
    sign_in FactoryGirl.create(:user)
    assert_difference('Dataset.count') do
      post :create, dataset: {title: 'my dataset' }
    end
  end

end
