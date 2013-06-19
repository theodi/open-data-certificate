require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "published certificates can be shown" do
    cert = FactoryGirl.create(:published_certificate)
    get :show, {id: cert.id}
    assert_response :success
  end

  test "unpublished certificates can't be shown" do
    cert = FactoryGirl.create(:certificate)
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, {id: cert.id}
    end
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
