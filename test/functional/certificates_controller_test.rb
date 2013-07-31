require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "index shows all published certificates" do
    5.times do
      FactoryGirl.create(:published_certificate)
    end
    5.times do
      FactoryGirl.create(:certificate)
    end

    get :index

    assert_response :success
    assert_equal 5, assigns(:certificates).size
    assert assigns(:certificates).first.published
  end

  test "published certificates can be shown" do
    cert = FactoryGirl.create(:published_certificate)
    get :show, {id: cert.id}
    assert_response :success
  end

  test "unpublished certificates can't be shown" do
    cert = FactoryGirl.create(:certificate)
    get :show, {id: cert.id}
    assert_response 404
  end

  test "unpublished certificates can be shown to their creator" do
    user = FactoryGirl.create(:user)
    sign_in user

    cert = FactoryGirl.create(:certificate)
    cert.response_set.assign_to_user! user
    
    get :show, {id: cert.id}
    
    assert_response :success
  end

end
