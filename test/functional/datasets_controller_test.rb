require 'test_helper'
require 'rss'

class DatasetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "index shows all published datasets" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end
    5.times do
      FactoryGirl.create(:certificate_with_dataset)
    end

    get :index

    assert_response :success
    assert_equal 5, assigns(:datasets).size
    assert assigns(:datasets).first.response_set.published?
  end

  test "index filters by jurisdiction" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    FactoryGirl.create(:published_certificate_with_dataset)
    FactoryGirl.create(:certificate_with_dataset)

    cert.response_set.survey.update_attribute(:title, 'UK')

    get :index, jurisdiction: 'UK'

    assert_response :success
    assert_equal [cert.dataset], assigns(:datasets)
  end

  test "index filters by publisher" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    FactoryGirl.create(:published_certificate_with_dataset)
    FactoryGirl.create(:certificate_with_dataset)

    cert.update_attribute(:curator, 'theodi')

    get :index, publisher: 'theodi'

    assert_response :success
    assert_equal [cert.dataset], assigns(:datasets)
  end

  test "index filters by datahub of documentation url" do
    example = FactoryGirl.create(:published_certificate_with_dataset)
    example.dataset.update_attribute(:documentation_url, 'http://example.org/data')
    data = FactoryGirl.create(:published_certificate_with_dataset)
    data.dataset.update_attribute(:documentation_url, 'http://data.org/data')

    get :index, :datahub => 'data.org'

    assert_response :success
    assert_equal [data.dataset], assigns(:datasets)
  end

  test "index filters by datahub of documentation url with https" do
    example = FactoryGirl.create(:published_certificate_with_dataset)
    example.dataset.update_attribute(:documentation_url, 'https://example.org/data')
    data = FactoryGirl.create(:published_certificate_with_dataset)
    data.dataset.update_attribute(:documentation_url, 'https://data.org/data')

    get :index, :datahub => 'data.org'

    assert_response :success
    assert_equal [data.dataset], assigns(:datasets)
  end

  %w[basic pilot standard exemplar].each do |level|
    test "index filters by #{level} level" do
      FactoryGirl.create(:published_basic_certificate_with_dataset)
      FactoryGirl.create(:published_pilot_certificate_with_dataset)
      FactoryGirl.create(:published_standard_certificate_with_dataset)
      FactoryGirl.create(:published_exemplar_certificate_with_dataset)

      get :index, :level => level

      assert_response :success
      assert_equal 1, assigns(:datasets).size
      assert_equal level, assigns(:datasets).first.certificate.attained_level
    end
  end

  test "index filters by modified date of datasets" do
    Timecop.freeze(3.days.ago) { FactoryGirl.create(:published_certificate_with_dataset) }
    FactoryGirl.create(:published_certificate_with_dataset)

    get :index, :since => 2.days.ago.iso8601

    assert_equal 1, assigns(:datasets).size
  end

  test "index ignores argument if dateformat is wrong" do
    Timecop.freeze(3.days.ago) { FactoryGirl.create(:published_certificate_with_dataset) }
    FactoryGirl.create(:published_certificate_with_dataset)

    get :index, :since => "2 days ago"

    assert_equal 2, assigns(:datasets).size
  end

  test "index (non logged in)" do
    get :dashboard
    assert_response :redirect
  end

  test "index no response sets" do
    sign_in FactoryGirl.create(:user)
    get :dashboard
    assert_response 200
  end

  test "index response sets" do
    sign_in FactoryGirl.create(:user_with_responses)
    get :dashboard
    assert_response 200
    assert assigns(:datasets).size > 0
  end

  test "dashboard doesn't show datasets without response sets" do
    user = FactoryGirl.create(:user)
    dataset1 = FactoryGirl.create(:dataset, user: user)
    dataset2 = FactoryGirl.create(:dataset, user: user)
    FactoryGirl.create(:published_response_set, dataset: dataset2)

    sign_in user

    get :dashboard
    assert_response 200
    assert_equal 1, assigns(:datasets).size
  end

  test "typeahead for datasets" do
    @first  = FactoryGirl.create(:dataset, title:'my first dataset')
    @second = FactoryGirl.create(:dataset, title:'my second dataset')

    FactoryGirl.create(:published_response_set, dataset: @first)
    FactoryGirl.create(:published_response_set, dataset: @second)

    get :typeahead, mode: 'dataset', q: 'second'
    assert_response 200

    assert_equal [
      {
        "attained_index" => nil,
        "value" =>'my second dataset',
        "path" => "/datasets/#{@second.id}"
      }
    ], assigns(:response)

  end

  test "typeahead for publisher" do
    @first  = FactoryGirl.create(:published_certificate_with_dataset)
    @first.curator = 'curator one'
    @first.save

    @second = FactoryGirl.create(:published_certificate_with_dataset)
    @second.curator = 'curator one'
    @second.save

    get :typeahead, mode: 'publisher', q: 'one'
    assert_response 200

    assert_equal [
      {
        "value" =>'curator one',
        "path" => "/datasets?publisher=curator+one"
      }
    ], assigns(:response)

  end

  test "typeahead for country" do
    FactoryGirl.create(:survey, full_title:'UnitedKingdam', title:'GB', survey_version: 1)
    @gb = FactoryGirl.create(:survey, full_title:'United Kingdom', title:'GB', survey_version: 2)
    FactoryGirl.create(:survey, full_title:'United States', title:'US')
    FactoryGirl.create(:survey, full_title:'Andorra', title: 'AD')

    # only shows countries with published response sets
    FactoryGirl.create(:response_set, survey: @gb).publish!

    get :typeahead, mode: 'country', q: 'united'
    assert_response 200

    assert_equal [
      {
        "value" =>'United Kingdom',
        "path" => "/datasets?jurisdiction=GB"
      }
    ], assigns(:response)

  end

  test "Requesting an Atom feed for a dataset returns Atom" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.attained_level = "basic"
    cert.save
    get :show, {id: cert.response_set.dataset.id, format: "feed"}
    assert_response :success
    assert_equal "application/atom+xml", response.content_type
  end

  test "Requesting an Atom feed for a dataset returns the correct stuff" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.attained_level = "basic"
    cert.save
    get :show, {id: cert.response_set.dataset.id, format: "feed"}
    assert_response :success

    feed = RSS::Parser.parse response.body, false

    assert_equal "http://test.host/datasets/#{cert.dataset.id}", feed.entry.links[1].href
    assert_equal "http://schema.theodi.org/certificate#certificate", feed.entry.links[2].rel
    assert_equal "http://test.host/datasets/#{cert.dataset.id}/certificate", feed.entry.links[2].href
    assert_equal "http://www.example.com", feed.entry.links[3].href
    assert_equal "about", feed.entry.links[3].rel
    assert_equal "http://test.host/datasets/#{cert.dataset.id}/certificate.json", feed.entry.links[4].href
    assert_equal "alternate", feed.entry.links[4].rel
    assert_equal "http://test.host/datasets/#{cert.dataset.id}/certificate/badge.html", feed.entry.links[5].href
    assert_equal "http://schema.theodi.org/certificate#badge", feed.entry.links[5].rel
    assert_equal "text/html", feed.entry.links[5].type
    assert_equal "http://test.host/datasets/#{cert.dataset.id}/certificate/badge.js", feed.entry.links[6].href
    assert_equal "http://schema.theodi.org/certificate#badge", feed.entry.links[6].rel
    assert_equal "application/javascript", feed.entry.links[6].type
  end

  test "Requesting an Atom feed for a dataset in production returns https urls" do
    Rails.env.stubs :production? => true

    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.attained_level = "basic"
    cert.save
    get :show, {id: cert.response_set.dataset.id, format: "feed"}
    assert_response :success

    feed = RSS::Parser.parse response.body, false

    assert_match /https:\/\//, feed.id.content
    assert_match /https:\/\//, feed.entry.links[0].href
    assert_match /https:\/\//, feed.entry.links[1].href
    assert_match /https:\/\//, feed.entry.links[2].href
    assert_match /https:\/\//, feed.entry.links[4].href
    assert_match /https:\/\//, feed.entry.links[5].href
  end

  test "Requesting an Atom feed for all datasets returns Atom" do
    10.times do
      cert = FactoryGirl.create(:published_certificate_with_dataset)
    end
    get :index, { format: "feed" }
    assert_response :success

    assert_equal "application/atom+xml", response.content_type
  end

  test "atom feed for all datasets returns the correct stuff" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)

    get :index, { :format => :feed }

    feed = RSS::Parser.parse response.body

    assert_response :success
    assert_equal 1, feed.entries.count
    assert_equal "http://test.host/datasets/#{cert.dataset.id}", feed.entry.links[0].href
    assert_equal "http://schema.theodi.org/certificate#certificate", feed.entry.links[1].rel
    assert_equal "http://test.host/datasets/#{cert.dataset.id}/certificate", feed.entry.links[1].href
    assert_equal "http://www.example.com", feed.entry.links[2].href
    assert_equal "about", feed.entry.links[2].rel
    assert_equal "http://test.host/datasets/#{cert.dataset.id}/certificate.json", feed.entry.links[3].href
    assert_equal "alternate", feed.entry.links[3].rel
    assert_equal "http://test.host/datasets/#{cert.dataset.id}/certificate/badge.html", feed.entry.links[4].href
    assert_equal "http://schema.theodi.org/certificate#badge", feed.entry.links[4].rel
    assert_equal "text/html", feed.entry.links[4].type
    assert_equal "http://test.host/datasets/#{cert.dataset.id}/certificate/badge.js", feed.entry.links[5].href
    assert_equal "http://schema.theodi.org/certificate#badge", feed.entry.links[5].rel
    assert_equal "application/javascript", feed.entry.links[5].type
  end

  test "atom feed for all datasets in production returns https urls" do
    Rails.env.stubs :production? => true

    cert = FactoryGirl.create(:published_certificate_with_dataset)

    get :index, { :format => :feed }

    feed = RSS::Parser.parse response.body

    assert_match /https:\/\//, feed.id.content
    assert_match /https:\/\//, feed.links[0].href
    assert_match /https:\/\//, feed.links[1].href
    assert_match /https:\/\//, feed.links[2].href
    assert_match /https:\/\//, feed.entry.links[1].href
    assert_match /https:\/\//, feed.entry.links[3].href
    assert_match /https:\/\//, feed.entry.links[4].href
    assert_match /https:\/\//, feed.entry.links[5].href
  end

  test "atom feed last modified header is updated_at date of most recent response_set" do
    Timecop.freeze(3.days.ago) { FactoryGirl.create(:published_certificate_with_dataset) }
    recent_time = 2.days.ago.change(:usec => 0).utc
    Timecop.freeze(recent_time) { FactoryGirl.create(:published_certificate_with_dataset) }

    get :index, format: :feed

    last_modified = @response.headers['Last-Modified']
    assert_equal recent_time.httpdate, last_modified
    feed = RSS::Parser.parse response.body
    assert_equal recent_time, feed.updated.content.utc
  end

  test "Requesting JSON for a search query returns JSON" do
    100.times do
      cert = FactoryGirl.create(:published_certificate_with_dataset)
    end
    get :index, { search: "", format: "json" }
    assert_response :success
    assert_equal "application/json", response.content_type
  end

  test "Requesting an Atom feed for a search query returns Atom" do
    100.times do
      cert = FactoryGirl.create(:published_certificate_with_dataset)
    end
    get :index, { search: "", format: "feed" }
    assert_response :success
    assert_equal "application/atom+xml", response.content_type
  end

  test "Requesting an Atom feed for a search query returns correct pagination" do
    100.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end
    get :index, { search: "Test", format: "feed" }
    assert_response :success

    doc = Nokogiri::XML(response.body)
    assert_match /page=4/, doc.css('link[rel="last"]').first[:href]
    assert_match /page=1/, doc.css('link[rel="first"]').first[:href]
    assert_match /page=2/, doc.css('link[rel="next"]').first[:href]
  end

  test "requesting a csv sends a redirect to rackspace location" do
    CSVExport.stubs(:download_url).returns("http://rackspace.example.com/open-data-certificates.csv")
    get :index, format: "csv"
    assert_response :redirect
    assert_equal "http://rackspace.example.com/open-data-certificates.csv", response.headers['Location']
  end

  test "requesting a csv when it's not generated returns a 404" do
    CSVExport.stubs(:download_url).raises(ActiveRecord::RecordNotFound)
    get :index, format: "csv"
    assert_response :not_found
  end

  %w[search since datahub level publisher jurisdiction].each do |term|
    test "requesting a csv with a filter of #{term} returns a 404" do
      get :index, term => "test", format: "csv"

      assert_response :not_found
    end
  end

  test "removed datasets are not shown in index" do
    FactoryGirl.create(:published_certificate_with_removed_dataset)
    FactoryGirl.create(:published_certificate_with_dataset)

    get :index

    assert_equal 1, assigns(:datasets).size

  end

  test "creating a certificate without a jurisdiction" do
    http_auth FactoryGirl.create(:user)
    post :create
    body = JSON.parse(response.body)
    assert_equal(422, response.status)
    assert_equal(false, body['success'])
    assert_equal(["Jurisdiction not found"], body['errors'])
  end

  test "creating a certificate requires some dataset information" do
    load_custom_survey 'cert_generator.rb'
    http_auth FactoryGirl.create(:user)
    post :create, jurisdiction: 'cert-generator'
    body = JSON.parse(response.body)
    assert_equal(422, response.status)
    assert_equal(false, body['success'])
    assert_equal(["Dataset information required"], body['errors'])
  end

  test "creates a certificate if draft certificates exist" do
    load_custom_survey 'cert_generator.rb'
    certificate = FactoryGirl.create(:certificate_with_dataset)
    dataset = certificate.dataset
    http_auth FactoryGirl.create(:user)

    CertificateGenerator.any_instance.stubs(:delay).returns CertificateGenerator.new
    CertificateGenerator.any_instance.expects(:generate).once

    assert_difference "CertificateGenerator.count", 1 do
      post :create, jurisdiction: 'cert-generator', dataset: {documentationUrl: dataset.documentation_url}
    end
    body = JSON.parse(response.body)
    assert_equal(202, response.status)
    assert_equal("pending", body['success'])
    assert_equal(dataset.id, body['dataset_id'])
    assert_equal(status_datasets_url(CertificateGenerator.last), body['dataset_url'])
  end

  test "failure to create a duplicate of a dataset with a published certificate" do
    load_custom_survey 'cert_generator.rb'
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    dataset = certificate.dataset
    http_auth FactoryGirl.create(:user)
    post :create, jurisdiction: 'cert-generator', dataset: {documentationUrl: dataset.documentation_url}
    body = JSON.parse(response.body)
    assert_equal(422, response.status)
    assert_equal(false, body['success'])
    assert_equal(dataset.id, body['dataset_id'])
    assert_equal(dataset_url(dataset, :format => :json), body['dataset_url'])
    assert_equal(["Dataset already exists"], body['errors'])
  end

  test "delays generating the certificate" do
    load_custom_survey 'cert_generator.rb'
    http_auth FactoryGirl.create(:user)

    CertificateGenerator.any_instance.stubs(:delay).returns CertificateGenerator.new
    CertificateGenerator.any_instance.expects(:generate).once

    assert_difference "CertificateGenerator.count", 1 do
      post :create, jurisdiction: 'cert-generator', dataset: {documentationUrl: "http://example.org"}
    end
    body = JSON.parse(response.body)
    assert_equal(202, response.status)
    assert_equal("pending", body['success'])
    assert_equal(status_datasets_url(CertificateGenerator.last), body['dataset_url'])
  end

  test "associates certificate generation with a campaign" do
    load_custom_survey 'cert_generator.rb'
    user = FactoryGirl.create(:user)
    http_auth user

    CertificateGenerator.any_instance.stubs(:delay).returns stub(generate: nil)

    assert_difference "CertificationCampaign.count", 1 do
      post :create, {
          :campaign => "fourmoreyears",
          :url => "http://example.org",
          :jurisdiction => 'cert-generator',
          dataset: {documentationUrl: "http://example.org"}
      }
    end

    CertificationCampaign.last.tap do |campaign|
      assert_equal('fourmoreyears', campaign.name)
      assert_equal(user, campaign.user)
    end
  end

  test "certificate campaigns are per user" do
    load_custom_survey 'cert_generator.rb'
    generating_user = FactoryGirl.create(:user)
    other_user = FactoryGirl.create(:user)
    http_auth generating_user

    CertificateGenerator.any_instance.stubs(:delay).returns stub(generate: nil)

    assert_difference "CertificationCampaign.count", 1 do
      post :create, jurisdiction: 'cert-generator',
        dataset: {documentationUrl: "http://example.org"},
        campaign: 'fourmoreyears'
    end

    assert CertificationCampaign.where(user_id: generating_user.id, name: 'fourmoreyears').exists?
    refute CertificationCampaign.where(user_id: other_user.id, name: 'fourmoreyears').exists?
  end

  test "pending status endpoint" do
    user = FactoryGirl.create(:user)
    http_auth user
    generator = CertificateGenerator.create(user: user)
    get :import_status, certificate_generator_id: generator.id
    body = JSON.parse(response.body)
    assert_equal("pending", body['success'])
    assert_equal(status_datasets_url(CertificateGenerator.last), body['dataset_url'])
  end

  test "completed status endpoint" do
    response_set = FactoryGirl.create(:response_set_with_dataset)
    response_set.publish_certificate
    user = response_set.user
    generator = CertificateGenerator.create(user: user, completed: true, response_set: response_set)
    http_auth user
    get :import_status, certificate_generator_id: generator.id
    assert_redirected_to dataset_url(response_set.dataset_id, format: :json)
    http_auth user
    get :show, id: response_set.dataset_id, format: :json
    body = JSON.parse(response.body)
    assert_equal(true, body['success'])
    assert_equal(response_set.dataset_id, body['dataset_id'])
    assert_equal(dataset_url(response_set.dataset_id, :format => :json), body['dataset_url'])
  end

  test "unpublished status endpoint" do
    response_set = FactoryGirl.create(:response_set_with_dataset)
    user = response_set.user
    generator = CertificateGenerator.create(user: user, completed: true, response_set: response_set)
    http_auth user
    get :import_status, certificate_generator_id: generator.id
    body = JSON.parse(response.body)
    assert_equal(false, body['success'])
    assert_equal(false, body['published'])
    assert_equal(response_set.dataset_id, body['dataset_id'])
    assert_equal(status_datasets_url(generator), body['dataset_url'])
  end

  test "status endpoint is limited to creating user" do
    generating_user = FactoryGirl.create(:user)
    other_user = FactoryGirl.create(:user)
    http_auth other_user
    generator = CertificateGenerator.create(user: generating_user)
    get :import_status, certificate_generator_id: generator.id
    assert_response 403
  end

  test "dataset info endpoint with no data" do
    get :info, format: :json
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal(0, body['published_certificate_count'])
  end

  test "dataset info with draft certificate" do
    FactoryGirl.create_list(:certificate_with_dataset, 3)
    get :info, format: :json
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal(0, body['published_certificate_count'])
  end

  test "dataset info with published certificates" do
    FactoryGirl.create_list(:published_certificate_with_dataset, 3)
    get :info, format: :json
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal(3, body['published_certificate_count'])
  end

  test "dataset info with published but expired certificates" do
    certs = FactoryGirl.create_list(:published_certificate_with_dataset, 3)
    certs.last.update_attribute(:expires_at, 1.day.ago)
    get :info, format: :json
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal(2, body['published_certificate_count'])
  end

  test "dataset is not visible if removed and not an admin" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.dataset.update_attribute(:removed, true)

    get :show, id: cert.dataset.id

    assert_response :not_found
  end

  test "dataset is visible if removed and admin" do
    user = FactoryGirl.create(:admin_user)
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.dataset.update_attribute(:removed, true)

    sign_in user
    get :show, id: cert.dataset.id

    assert_response :ok
  end

  test "link header is present" do
    FactoryGirl.create_list(:published_certificate_with_dataset, 20*2)
    get :index
    assert response.headers['Link']
  end

  test "first link is present in link header" do
    FactoryGirl.create_list(:published_certificate_with_dataset, 20)
    get :index
    links = split_link_header(response.headers['Link'])
    assert_equal datasets_url, links['first']
  end

  test "last link is present in link header if more than one page" do
    FactoryGirl.create_list(:published_certificate_with_dataset, 20*3)
    get :index
    links = split_link_header(response.headers['Link'])
    assert_equal datasets_url(page: 3), links['last']
  end

  test "last link is not present if only one page of results" do
    FactoryGirl.create_list(:published_certificate_with_dataset, 10)
    get :index
    links = split_link_header(response.headers['Link'])
    assert_nil links['last']
  end

  test "adds format to link urls if format not html" do
    FactoryGirl.create_list(:published_certificate_with_dataset, 20*4)
    get :index, page: 3, format: :json
    links = split_link_header(response.headers['Link'])
    assert_equal datasets_url(format: :json), links['first']
    assert_equal datasets_url(format: :json, page: 4), links['last']
    assert_equal datasets_url(format: :json, page: 4), links['next']
    assert_equal datasets_url(format: :json, page: 2), links['prev']
  end

  test "does not use page=1 param for first page" do
    FactoryGirl.create_list(:published_certificate_with_dataset, 20*2)
    get :index, page: 2, format: :json
    links = split_link_header(response.headers['Link'])
    assert_equal datasets_url(format: :json), links['first']
    assert_equal datasets_url(format: :json), links['prev']
  end

  def split_link_header(value)
    links = value.split(',').map(&:strip)
    links.inject({}) do |h, val|
      href, rel = val.match(/<(.*?)>;.*rel=(.*)/)[1,2]
      h[rel] = href
      h
    end
  end
end
