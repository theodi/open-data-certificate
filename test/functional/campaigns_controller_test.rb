require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should list all campaigns" do
    get :index
    assert_response :success
  end

  test "should 404 if campaign not found" do
    get :show, id: 'parp'
    assert_response :not_found
  end

  test "should show details for a single campaign" do
    FactoryGirl.create :certification_campaign, name: 'data.gov.uk'
    get :show, id: 'data.gov.uk'
    assert_response :success
  end

end
