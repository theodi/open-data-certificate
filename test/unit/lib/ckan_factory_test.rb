require_relative '../../test_helper'

class CKANFactoryTest < ActiveSupport::TestCase

  def setup
    @campaign = CertificationCampaign.create(name: "Test campaign", url: "http://data.gov.uk/api")
    @result = { help: "http://data.gov.uk/api/3/action/help_show?name=package_search", 
        success: true, 
        result: {
          count: 100,
          sort: "score desc, popularity desc, name asc",
          facets: {},
          results: [{
              "license_title" => "UK Open Government Licence (OGL)",
              "author" => "VOSA, Freedom of Information, Berkeley House, Croydon Street, Bristol, BS5 0DA",
              "author_email" => "inform@vosa.gov.uk",
              "state" => "active",
              "contact-email" => "informationhandling@dft.gsi.gov.uk ",
              "title" => "Active Vehicle Testing Stations in Great Britain",
              "contact-name" => "Information Handling Team ",
              "name" => "mot-active-vts",
              "isopen" => true,
              "resources" => [],
              "type" => "dataset",
              "update_frequency" => "quarterly",
              "theme-primary" => "Transport"
            }],
          search_facets: {}
        }
      }
  end

  test "builds a basic url" do
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    assert_equal "http://data.gov.uk/api/3/action/package_search?rows=10&start=0", factory.url
  end

  test "builds a dataset url" do
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    assert_equal "http://data.gov.uk/dataset/mot-active-vts", factory.get_dataset_url({ "name" => "mot-active-vts", })
  end

  test "can make a request" do
    stub_request(:any, "http://data.gov.uk/api/3/action/package_search?rows=10&start=0")
      .to_return(:body => @result.to_json, status: 200)
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    assert_equal false, factory.feed_items.blank?
  end

  test "fails when campaign_id is blank" do
    assert_raises ActiveRecord::RecordNotFound do
      factory = CertificateFactory::CKANFactory.new({ campaign_id: nil, rows:10, params:{} })
    end
  end

  test "builds a url with an organization filter query" do
    @campaign.update_attribute(:subset, { organization: "chorley-council" })
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    assert_true factory.url.include?("fq=%2Borganization%3Achorley-council")
  end

  test "builds a url with multiple filters" do
    @campaign.update_attribute(:subset, { organization: "chorley-council", tags: 'economy' })
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    assert_true factory.url.include?("fq=%2Borganization%3Achorley-council%2Btags%3Aeconomy")
  end

  test "ignore filters with blank values" do
    @campaign.update_attribute(:subset, { tags: "", organization: "chorley-council" })
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    assert_true !factory.url.include?("%2Btags")
  end

  test "builds a basic url for campaign prefetch" do
    campaign = CertificationCampaign.new(name: "Test campaign", url: "http://data.gov.uk/api")
    factory = CertificateFactory::CKANFactory.new({ is_prefetch: true, campaign: campaign, rows:10, params:{} })
    assert_equal "http://data.gov.uk/api/3/action/package_search?rows=10&start=0", factory.url
  end

  test "can make a request in prefetch" do
    stub_request(:any, "http://data.gov.uk/api/3/action/package_search?rows=10&start=0")
      .to_return(:body => @result.to_json, status: 200)
    campaign = CertificationCampaign.new(name: "Test campaign", url: "http://data.gov.uk/api")
    factory = CertificateFactory::CKANFactory.new({ is_prefetch: true, campaign: campaign, rows:10, params:{} })
    assert_equal false, factory.feed_items.blank?
  end

end