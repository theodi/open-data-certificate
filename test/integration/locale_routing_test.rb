require_relative '../test_helper'

class LocaleRoutingTest < ActionDispatch::IntegrationTest

  test "route with a locale succedes" do
    get '/en/privacy-policy'
    assert_response :success
  end

  test "route with a non-default locale succedes" do
    get '/cs/privacy-policy'
    assert_response :success
  end

  test "route missing locale gets redirected to default locale" do
    get '/privacy-policy'
    assert_response 301
    assert_redirected_to '/en/privacy-policy'
  end

  test "route with a locale to a missing page responds with a routing error" do
    assert_raises(ActionController::RoutingError) {
      get '/en/does_not_exist'
    }
  end

end
