require_relative '../../test_helper'

class CKANFactoryTest < ActiveSupport::TestCase

  def setup
    @campaign = CertificationCampaign.create(name: "Test campaign", url: "http://data.gov.uk/")
  end

  test "builds a basic url" do
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    assert_equal "http://data.gov.uk/api/3/action/package_search?rows=10&start=0", factory.url
  end

  test "builds a url with an organization filter query" do
    @campaign.update_attribute(:subset, { fq: "organization:chorley-council" })
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    assert_true factory.url.include?("fq=organization%3Achorley-council")
  end  

end
