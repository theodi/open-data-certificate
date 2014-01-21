require 'test_helper'

class ApiAuthenticationTest < ActionDispatch::IntegrationTest

  def setup
    @user = FactoryGirl.create :user, email: 'test@example.com', authentication_token: 'test1234'
  end

  test "Unauthorised user tries to create a dataset" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    post "/datasets", {}, {'Username' => 'test@example.com', 'Token' => 'test123'}
    assert_response :unauthorized
  end

  test "Authorised user tries to create a dataset" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    post "/datasets", {}, {'Username' => 'test@example.com', 'Token' => 'test1234'}
    assert_response :success
  end
end
