require 'test_helper'
require "base64"

class ApiAuthenticationTest < ActionDispatch::IntegrationTest

  def setup
    @user = FactoryGirl.create :user, email: 'test@example.com', authentication_token: 'test1234'
  end

  test "Unauthorised user tries to create a dataset" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    post "/datasets", {}, {"HTTP_AUTHORIZATION" => "Basic "+Base64.encode64('test@example.com:test123').gsub(/\n/, '')}
    assert_response :unauthorized
  end

  test "Authorised user tries to create a dataset" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    post "/datasets", {}, {"HTTP_AUTHORIZATION" => "Basic "+Base64.encode64('test@example.com:test1234').gsub(/\n/, '')}
    assert_response :unprocessable_entity
  end
end
