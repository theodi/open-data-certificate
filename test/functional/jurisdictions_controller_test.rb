require 'test_helper'

class JurisdictionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, use_route: :surveyor
    assert_response :success
  end

end
