require_relative '../../test_helper'

class CKANFactoryTest < ActiveSupport::TestCase

  def setup
    @user = FactoryGirl.create :user, :admin => true
    @campaign = CertificationCampaign.create(name: "Test campaign", url: "http://data.gov.uk/api", jurisdiction: "blank")
    @campaign.update_attribute(:user_id, @user.id)
    @result = { help: "http://data.gov.uk/api/3/action/help_show?name=package_search", 
        success: true, 
        result: {
          count: 2,
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
            },{
              "license_title" => "UK Open Government Licence (OGL)",
              "author" => "VOSA, Freedom of Information, Berkeley House, Croydon Street, Bristol, BS5 0DA",
              "author_email" => "inform@vosa.gov.uk",
              "state" => "active",
              "contact-email" => "informationhandling@dft.gsi.gov.uk ",
              "title" => "Threatened Species and Ecological Communities of National Environmental Significance",
              "contact-name" => "Information Handling Team ",
              "name" => "threatened-species-state-lists",
              "isopen" => true,
              "resources" => [],
              "type" => "dataset",
              "harvest_source_title" => "data.gov.au",
              "extras" => [{
                "value" => "http://data.gov.au/dataset/ae652011-f39e-4c6c-91b8-1dc2d2dfee8f",
                "key" => "harvest_url"
              }]
            }],
          search_facets: {}
        }
      }

    @dataset_result = {
      "help" => "http://data.gov.uk/api/3/action/help_show?name=package_show",
      "success" => true,
      "result" => {
        "title" => "Active Vehicle Testing Stations in Great Britain",
        "license_title" => "UK Open Government Licence (OGL)"
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

  test "gets dataset urls for hosted and harvested datasets" do
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{}, include_harvested: true })

    hosted = "http://data.gov.uk/dataset/mot-active-vts"
    harvested = "http://data.gov.au/dataset/ae652011-f39e-4c6c-91b8-1dc2d2dfee8f"

    assert_equal hosted, factory.get_dataset_url(@result[:result][:results][0])
    assert_equal harvested, factory.get_dataset_url(@result[:result][:results][1])
  end

  test "excludes dataset urls for harvested datasets by default" do
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    harvested = "http://data.gov.au/dataset/ae652011-f39e-4c6c-91b8-1dc2d2dfee8f"
    assert_equal nil, factory.get_dataset_url(@result[:result][:results][1])
  end

  test "creates certificates on build" do
    load_custom_survey 'blank.rb'

    stub_request(:any, "http://data.gov.uk/api/3/action/package_search?rows=10&start=0")
      .to_return(:body => @result.to_json, status: 200)

    stub_request(:any, "http://data.gov.uk/dataset/mot-active-vts")
      .to_return(:body => @dataset_result.to_json, status: 200)
    
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    factory.build

    assert_equal 1, @campaign.reload.dataset_count
    assert_equal 1, CertificateGenerator.count
  end

  test "creates certificates including harvested on build" do
    load_custom_survey 'blank.rb'

    stub_request(:any, "http://data.gov.uk/api/3/action/package_search?rows=10&start=0")
      .to_return(:body => @result.to_json, status: 200)

    stub_request(:any, "http://data.gov.uk/dataset/mot-active-vts")
      .to_return(:body => @dataset_result.to_json, status: 200)

    stub_request(:any, "http://data.gov.au/dataset/ae652011-f39e-4c6c-91b8-1dc2d2dfee8f")
      .to_return(:body => @dataset_result.to_json, status: 200)

    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{}, include_harvested: true })
    factory.build

    assert_equal @result[:result][:count], @campaign.reload.dataset_count
    assert_equal @result[:result][:count], CertificateGenerator.count
  end
  
  test "saves dataset count" do
    stub_request(:any, "http://data.gov.uk/api/3/action/package_search?rows=10&start=0")
      .to_return(:body => @result.to_json, status: 200)
    factory = CertificateFactory::CKANFactory.new({ campaign_id: @campaign.id, rows:10, params:{} })
    factory.save_dataset_count
    assert_equal @result[:result][:count], @campaign.reload.dataset_count
  end

end