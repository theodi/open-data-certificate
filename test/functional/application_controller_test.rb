require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "homepage" do
    get :home
    assert_response 200
  end

  test "has_js" do
    get :has_js
    assert_response 200
    assert_equal session[:surveyor_javascript], 'enabled'
  end

end
