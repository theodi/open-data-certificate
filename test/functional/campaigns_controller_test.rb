require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should list all campaigns" do
    get :index
    assert_response :success
  end

end
