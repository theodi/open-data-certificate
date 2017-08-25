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
    assert_redirected_to '/en/privacy-policy'
  end

  test "route with a locale to a missing page responds with a routing error" do
    assert_raises(ActionController::RoutingError) {
      get '/en/does_not_exist'
    }
  end

  test "route to a missing page gives a 404 result" do
    get '/does_not_exist'
    assert_response :not_found
  end

  context "with a signed-in user" do
    setup do
      user = FactoryGirl.create(:user, preferred_locale: 'cs')
      post_via_redirect '/users/sign_in', "user[email]" => user.email, "user[password]" => 'testpassword'
    end

    should "redirect to the user's preferred locale" do
      get '/privacy-policy'
      assert_redirected_to '/cs/privacy-policy'
    end
  end

end
