require_relative '../test_helper'

class CampaignsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "should list all campaigns" do
    get :index
    assert_response :success
  end

  test "should 404 if campaign not found" do
    get :show, id: 'parp'
    assert_response :not_found
  end

  test "should show details for a single campaign" do
    campaign = FactoryGirl.create :certification_campaign, name: 'data.gov.uk', user: @user
    get :show, id: campaign.id
    assert_response :success
  end

end
