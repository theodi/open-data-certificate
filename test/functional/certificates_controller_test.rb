require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "published certificates can be shown" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get :show, {dataset_id: cert.dataset.id, id: cert.id}
    assert_response :success
  end

  test "unpublished certificates can't be shown" do
    cert = FactoryGirl.create(:certificate_with_dataset)
    get :show, {dataset_id: cert.dataset.id, id: cert.id}
    assert_response 404
  end
  
  test "unpublished certificates can be shown to their creator" do
    user = FactoryGirl.create(:user)
    sign_in user
  
    cert = FactoryGirl.create(:certificate_with_dataset)
    cert.response_set.assign_to_user! user
    
    get :show, {dataset_id: cert.dataset.id, id: cert.id}
    
    assert_response :success
  end
  
  test "Requesting a JSON version of a certificate returns JSON" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.attained_level = "basic"
    cert.save 
    get :show, {dataset_id: cert.dataset.id, id: cert.id, format: "json"}
    assert_response :success
    assert_equal "application/json", response.content_type
  end

  test "mark certificate as valid" do
    cert = FactoryGirl.create(:certificate_with_dataset)
    user = FactoryGirl.create(:user)
    sign_in user

    assert_difference ->{cert.verifications.count}, 1 do
      post :verify, {dataset_id: cert.dataset.id, id: cert.id}
    end
  end

  test "sign in to mark certificate as valid" do
    cert = FactoryGirl.create(:certificate_with_dataset)
    user = FactoryGirl.create(:user)

    assert_no_difference ->{cert.verifications.count} do
      post :verify, {dataset_id: cert.dataset.id, id: cert.id}
    end

    assert_redirected_to dataset_certificate_url dataset_id: cert.dataset.id, id: cert.id

  end

  test "undo validation" do
    cv = FactoryGirl.create :verification
    cert = cv.certificate
    sign_in cv.user

    assert_difference ->{cert.verifications.count}, -1 do
      post :verify, {dataset_id: cert.dataset.id, id: cert.id, undo: true}
    end
  end

end
