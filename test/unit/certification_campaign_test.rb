require_relative '../test_helper'

class CertificationCampaignTest < ActiveSupport::TestCase

  def setup
    @user = FactoryGirl.create :user
  end

  test "determines CKAN factory" do
    campaign = CertificationCampaign.new(url: "http://data.gov.uk/")
    assert_equal campaign.factory, CertificateFactory::CKANFactory
  end

end
