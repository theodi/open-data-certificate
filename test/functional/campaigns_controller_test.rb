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

  test "creating a campaign enqueues a processing job" do
    CertificateFactory::FactoryRunner.expects(:perform_async)
    Sidekiq::Testing.fake! do
      post :create, :certification_campaign => FactoryGirl.attributes_for(:certification_campaign)
    end
    campaign = CertificationCampaign.last
    assert_redirected_to campaign_path(campaign, certificate_level: 'all')
  end

  test "updating a campaign enqueues a processing job" do
    campaign = FactoryGirl.create :certification_campaign, name: 'data.gov.uk', user: @user
    campaign.certificate_generators.create FactoryGirl.attributes_for(:certificate_generator).merge(completed: true)
    CertificateGeneratorUpdateWorker.expects(:perform_async).returns(nil)
    Sidekiq::Testing.fake! do
      post :queue_update, campaign_id: campaign.id
    end
    campaign = CertificationCampaign.last
    assert_redirected_to campaign_path(campaign, certificate_level: 'all')
  end

end
