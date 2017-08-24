require_relative '../test_helper'
require 'mocha/setup'

class KittenDataTest < ActiveSupport::TestCase

  class DataKitten::Dataset
    # this prevents DataKitten from making a request to the access_url
    def supported?
      true
    end
  end

  def set_normal_data

    distribution = DataKitten::Distribution.new(self, {})
    distribution.tap do |d|
      d.title = 'test_title'
      d.description = 'test_description'
      d.issued = Date.parse('2010-01-01')
      d.modified = Date.parse('2010-01-02')
      d.access_url = 'http://example.com/dataset'
      d.download_url = 'http://example.com/distribution'
      d.byte_size = 1000
      d.media_type = 'text/plain'
      d.extension = 'txt'
      d.format = DataKitten::DistributionFormat.new(d)
    end

    publisher = DataKitten::Agent.new(
      name: 'test_name',
      homepage: 'http://example.com/homepage',
      mbox: 'test_contact'
    )

    rights = DataKitten::Rights.new(
      uri: 'http://example.com/rights',
      dataLicense: "http://opendatacommons.org/licenses/pddl/",
      contentLicense: "http://creativecommons.org/licenses/by/2.0/uk/"
    )

    license = DataKitten::License.new(uri: "http://opendatacommons.org/licenses/by/")

    temporal = DataKitten::Temporal.new(start: Date.new, end: Date.new)

    spatial = {
      "type" => "Polygon",
      "coordinates" => [[
        [0,0],
        [0,1],
        [1,1],
        [1,0],
        [0,0]
      ]]
    }

    data = {
      data_title: 'test_title',
      description: 'test_description',
      identifier: 'test',
      landing_page: 'http://example.org/dataset',
      publishers: [publisher],
      rights: rights,
      licenses: [license],
      update_frequency: 'test_frequency',
      keywords: ['test', 'unit'],
      theme: 'test',
      issued: Date.new,
      modified: Date.new,
      temporal: temporal,
      spatial: spatial,
      language: 'en-us',
      distributions: [distribution]
    }

    data.each do |key, value|
      DataKitten::Dataset.any_instance.stubs(key).returns(value)
    end
  end

  def set_blank_data
    data = {
      data_title: nil
    }

    data.each do |key, value|
      DataKitten::Dataset.any_instance.stubs(key).returns(value)
    end
  end

  def set_minimum_data
    data = {
      data_title: 'test',
      description: nil,
      identifier: nil,
      landing_page: nil,
      publishers: nil,
      rights: nil,
      licenses: nil,
      update_frequency: nil,
      keywords: nil,
      theme: nil,
      issued: nil,
      modified: nil,
      temporal: nil,
      spatial: nil,
      language: nil,
      distributions: nil
    }

    data.each do |key, value|
      DataKitten::Dataset.any_instance.stubs(key).returns(value)
    end
  end

  def set_us_data(organization_type = "Federal Government")
    source = {
      "organization" => {"id" => "gov-agency", "name" => "gov-agency" }
    }
    organization = {
      "extras" => {"organization_type" => organization_type}
    }

    DataKitten::Dataset.any_instance.stubs(:source).returns(source)
    stub_request(:get, 'http://catalog.data.gov/some_data').to_return(status: 200)
    stub_request(:get, 'http://catalog.data.gov/api/2/rest/group/gov-agency').to_return(body: organization.to_json)
  end

  def set_ckan3_organization_data(name = "org-name")
    organization = {
      "id" => name,
      "name" => name
    }
    source = {
      "organization" => organization
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)
    stub_request(:get, "http://example.com/api/3/action/organization_show?id=#{name}").to_return(body: organization.to_json)
  end

  def setup
    stub_request(:get, "http://www.example.com").to_return(status: 200)
    set_normal_data
    @kitten_data = nil
  end

  def kitten_data
    @kitten_data ||= KittenData.new(url: 'http://www.example.com')
  end

  test 'Correct data is extracted from Data Kitten' do
    distributions = [{
      title: 'test_title',
      description: 'test_description',
      issued: Date.parse('2010-01-01'),
      modified: Date.parse('2010-01-02'),
      access_url: 'http://example.com/dataset',
      download_url: 'http://example.com/distribution',
      byte_size: 1000,
      media_type: 'text/plain',
      open: nil,
      extension: :txt,
      structured: nil
    }]

    assert_equal 'test_title', kitten_data.data[:title]
    assert_equal 'test_description', kitten_data.data[:description]
    assert_equal 'test', kitten_data.data[:identifier]
    assert_equal 'http://example.org/dataset', kitten_data.data[:landing_page]
    assert_equal 1, kitten_data.data[:publishers].length
    assert_kind_of DataKitten::Agent, kitten_data.data[:publishers][0]
    assert_kind_of DataKitten::Rights, kitten_data.data[:rights]
    assert_equal 1, kitten_data.data[:licenses].length
    assert_kind_of DataKitten::License, kitten_data.data[:licenses][0]
    assert_equal 'test_frequency', kitten_data.data[:update_frequency]
    assert_equal ['test', 'unit'], kitten_data.data[:keywords]
    assert_equal 'test', kitten_data.data[:theme]
    assert_kind_of Date, kitten_data.data[:release_date]
    assert_kind_of Date, kitten_data.data[:modified_date]
    assert_kind_of DataKitten::Temporal, kitten_data.data[:temporal_coverage]
    assert_equal 'Polygon', kitten_data.data[:spatial_coverage]['type']
    assert_equal [[0,0], [0,1], [1,1], [1,0], [0,0]], kitten_data.data[:spatial_coverage]['coordinates'][0]
    assert_equal 'en-us', kitten_data.data[:language]
    assert_equal distributions, kitten_data.data[:distributions]
  end

  test 'Nil data is extracted from Data Kitten in the correct format' do
    set_minimum_data

    assert_equal 'test', kitten_data.data[:title]
    assert_nil kitten_data.data[:description]
    assert_nil kitten_data.data[:identifier]
    assert_nil kitten_data.data[:landing_page]
    assert_equal [], kitten_data.data[:publishers]
    assert_nil kitten_data.data[:rights]
    assert_equal [], kitten_data.data[:licenses]
    assert_nil kitten_data.data[:update_frequency]
    assert_equal [], kitten_data.data[:keywords]
    assert_nil kitten_data.data[:theme]
    assert_nil kitten_data.data[:release_date]
    assert_nil kitten_data.data[:modified_date]
    assert_nil kitten_data.data[:temporal_coverage]
    assert_nil kitten_data.data[:spatial_coverage]
    assert_nil kitten_data.data[:language]
    assert_equal [], kitten_data.data[:distributions]
  end

  test 'Fields are empty if data request failed' do
    DataKitten::Dataset.expects(:new).raises
    assert_equal({}, kitten_data.fields)
  end

  test 'Publisher fields are set correctly' do
    assert_equal 'test_name', kitten_data.fields["publisher"]
    assert_equal 'http://example.com/homepage', kitten_data.fields["publisherUrl"]
    assert_equal 'test_contact', kitten_data.fields["contactEmail"]
  end

  test 'Data website is set to publisher website' do
    assert_equal 'true', kitten_data.fields["onWebsite"]
    assert_equal 'http://example.com/homepage', kitten_data.fields["webpage"]
  end

  test 'Data website is set to base url by default' do
    set_minimum_data

    assert_equal 'true', kitten_data.fields["onWebsite"]
    assert_equal 'http://www.example.com/', kitten_data.fields["webpage"]
  end

  test 'Release type is detected as a one off' do
    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns(nil)

    assert_equal 'oneoff', kitten_data.fields["releaseType"]
  end

  test 'Dataset URL is detected correctly' do
    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns(nil)

    assert_equal 'http://example.com/distribution', kitten_data.fields["datasetUrl"]
  end

  test 'Release type is detected as a collection (from distributions)' do
    distribution = DataKitten::Distribution.new(self, {})
    distribution.format = DataKitten::DistributionFormat.new(distribution)

    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns(nil)
    DataKitten::Dataset.any_instance.stubs(:distributions).returns([distribution, distribution])

    assert_equal 'collection', kitten_data.fields["releaseType"]
  end

  test 'Release type is detected as a collection (from metadata)' do
    source = {
      "extras" => { "collection_metadata" => "true" }
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)

    assert_equal 'collection', kitten_data.fields["releaseType"]
  end

  test 'Release type is detected as a series' do
    distribution = DataKitten::Distribution.new(self, {})
    distribution.format = DataKitten::DistributionFormat.new(distribution)

    DataKitten::Dataset.any_instance.stubs(:distributions).returns([distribution, distribution])

    assert_equal 'series', kitten_data.fields["releaseType"]
  end

  test 'Release type is detected as a service when API is mentioned in the description' do
    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns(nil)
    DataKitten::Dataset.any_instance.stubs(:description).returns('This is an API')

    assert_equal 'service', kitten_data.fields["releaseType"]
  end

  test 'Release type is detected as a service when one of the distributions is an API' do
    source = {
      "resources" => [{ "resource_type" => "api" }]
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)

    assert_equal 'service', kitten_data.fields["releaseType"]
  end

  test 'Release type is detected from provided field' do
    source = {
      "extras" => { "resource-type" => "service" }
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)
    assert_equal 'service', kitten_data.fields["releaseType"]
  end

  test 'Service type is detected as changing when update frequency is specified' do
    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns('daily')
    DataKitten::Dataset.any_instance.stubs(:description).returns('This is an API')

    assert_equal "changing", kitten_data.fields["serviceType"]
  end

  test 'Data type is detected as geographic from metadata' do
    source = {
      "extras" => { "metadata_type" => "geospatial" }
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)

    assert_equal ["geographic"], kitten_data.fields["dataType"]
  end

  test 'Frequently changing data detected when update frequency is at least daily' do
    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns('daily')

    assert_equal "true", kitten_data.fields["frequentChanges"]
  end

  test 'Data does not frequently change when update frequency is less often than daily' do
    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns('monthly')

    assert_equal "false", kitten_data.fields["frequentChanges"]
  end

  test 'Technical documentation is detected when there is a documentation resource' do
    source = {
      "resources" => [{
        "url" => "http://example.org/docs",
        "resource_type" => "documentation"
      }]
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)

    assert_equal "http://example.org/docs", kitten_data.fields["technicalDocumentation"]
  end

  test 'Is timestamped if temporal is specified' do
    assert_equal "timestamped", kitten_data.fields["timeSensitive"]
  end

  test 'Rights fields are set correctly' do
    assert_equal "yes", kitten_data.fields["publisherRights"]
    assert_equal 'http://example.com/rights', kitten_data.fields["copyrightURL"]
    assert_equal "odc_pddl", kitten_data.fields["dataLicence"]
    assert_equal "cc_by", kitten_data.fields["contentLicence"]
  end

  test 'Standard license fields are set correctly' do
    DataKitten::Dataset.any_instance.stubs(:rights).returns(nil)

    assert_equal "yes", kitten_data.fields["publisherRights"]
    assert_equal "odc_by", kitten_data.fields["dataLicence"]
  end

  test 'OGL content license is set to match data license' do
    license = DataKitten::License.new({})
    license.uri = "http://reference.data.gov.uk/id/open-government-licence"
    license.abbr = "ogl-uk"
    DataKitten::Dataset.any_instance.stubs(:licenses).returns([license])
    DataKitten::Dataset.any_instance.stubs(:rights).returns(nil)

    assert_equal "yes", kitten_data.fields["publisherRights"]
    assert_equal "ogl_uk", kitten_data.fields["dataLicence"]
    assert_equal "ogl_uk", kitten_data.fields["contentLicence"]
  end

  test 'If the data license covers content, set it also as a content license' do
    license = DataKitten::License.new({})
    license.abbr = "cc-zero"
    DataKitten::Dataset.any_instance.stubs(:licenses).returns([license])
    DataKitten::Dataset.any_instance.stubs(:rights).returns(nil)

    assert_equal "yes", kitten_data.fields["publisherRights"]
    assert_equal "cc_zero", kitten_data.fields["dataLicence"]
    assert_equal "cc_zero", kitten_data.fields["contentLicence"]
  end

  test 'If the data license does not cover content, do not set content license' do
    license = DataKitten::License.new({})
    license.abbr = "odc-pddl"
    DataKitten::Dataset.any_instance.stubs(:licenses).returns([license])
    DataKitten::Dataset.any_instance.stubs(:rights).returns(nil)

    assert_equal "yes", kitten_data.fields["publisherRights"]
    assert_equal "odc_pddl", kitten_data.fields["dataLicence"]
    assert_nil kitten_data.fields["contentLicence"]
  end

  test 'Ordinance Survey license fields are set correctly' do
    license = DataKitten::License.new({})
    license.uri = "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf"
    DataKitten::Dataset.any_instance.stubs(:licenses).returns([license])
    DataKitten::Dataset.any_instance.stubs(:rights).returns(nil)

    assert_equal "other", kitten_data.fields["dataLicence"]
    assert_equal "other", kitten_data.fields["contentLicence"]
    assert_equal "OS OpenData Licence", kitten_data.fields["otherDataLicenceName"]
    assert_equal "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf", kitten_data.fields["otherDataLicenceURL"]
    assert_equal "true", kitten_data.fields["otherDataLicenceOpen"]
    assert_equal "OS OpenData Licence", kitten_data.fields["otherContentLicenceName"]
    assert_equal "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf", kitten_data.fields["otherContentLicenceURL"]
    assert_equal "true", kitten_data.fields["otherContentLicenceOpen"]
  end

  test 'data.gov.uk assumptions are applied' do
    source = {
      "extras" => { "sla" => "true" }
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)
    DataKitten::Dataset.any_instance.stubs(:publishing_format).returns(:ckan)

    stub_request(:get, 'http://data.gov.uk/some_crazy_data').to_return(status: 200)
    @kitten_data = KittenData.new(url: 'http://data.gov.uk/some_crazy_data')

    assert_equal "true", kitten_data.fields["publisherOrigin"]
    assert_equal "not_personal", kitten_data.fields["dataPersonal"]
    assert_equal "false", kitten_data.fields["frequentChanges"]
    assert_equal kitten_data.url, kitten_data.fields["copyrightURL"]
    assert_equal "true", kitten_data.fields["listed"]
    assert_equal "http://data.gov.uk/some_crazy_data", kitten_data.fields["contactUrl"]
    assert_equal "http://data.gov.uk/", kitten_data.fields["listing"]
    assert_equal "samerights", kitten_data.fields["contentRights"]
    assert_equal ["list"], kitten_data.fields["versionManagement"]
    assert_equal "http://data.gov.uk/api/rest/package/some_crazy_data", kitten_data.fields["versionsUrl"]
    assert_equal "http://data.gov.uk/some_crazy_data", kitten_data.fields["slaUrl"]
    assert_equal "medium", kitten_data.fields["onGoingAvailability"]
    assert_equal "http://data.gov.uk/some_crazy_data#comments-container", kitten_data.fields["forum"]
  end

  test 'listing is set to publisher filter' do
    set_ckan3_organization_data('dept-name')
    assert_equal "http://www.example.com/publisher/dept-name", kitten_data.fields["listing"]
  end

  test 'listing for data.gov is set to group filter' do
    set_us_data
    @kitten_data = KittenData.new(url: 'http://catalog.data.gov/some_data')
    assert_equal "http://catalog.data.gov/group/gov-agency", kitten_data.fields["listing"]
  end

  test 'data.london.gov.uk assumptions are applied' do
    stub_request(:get, 'http://data.london.gov.uk/some_data').to_return(status: 200)
    @kitten_data = KittenData.new(url: 'http://data.london.gov.uk/some_data')
    DataKitten::Dataset.any_instance.stubs(:publishing_format).returns(:ckan)

    assert_equal "true", kitten_data.fields["publisherOrigin"]
    assert_equal "not_personal", kitten_data.fields["dataPersonal"]
    assert_equal "false", kitten_data.fields["frequentChanges"]
    assert_equal kitten_data.url, kitten_data.fields["copyrightURL"]
    assert_equal "true", kitten_data.fields["listed"]
    assert_equal "http://data.london.gov.uk/some_data", kitten_data.fields["contactUrl"]
    assert_equal "http://data.london.gov.uk/", kitten_data.fields["listing"]
    assert_equal "samerights", kitten_data.fields["contentRights"]
    assert_equal ["list"], kitten_data.fields["versionManagement"]
    assert_equal "http://data.london.gov.uk/api/rest/package/some_data", kitten_data.fields["versionsUrl"]
  end

  test 'data.gov assumptions are applied' do
    stub_request(:get, 'http://catalog.data.gov/some_data').to_return(status: 200)
    @kitten_data = KittenData.new(url: 'http://catalog.data.gov/some_data')
    DataKitten::Dataset.any_instance.stubs(:publishing_format).returns(:ckan)

    assert_equal "true", kitten_data.fields["publisherOrigin"]
    assert_equal "not_personal", kitten_data.fields["dataPersonal"]
    assert_equal "false", kitten_data.fields["frequentChanges"]
    assert_equal kitten_data.url, kitten_data.fields["copyrightURL"]
    assert_equal "true", kitten_data.fields["listed"]
    assert_equal "http://catalog.data.gov/some_data", kitten_data.fields["contactUrl"]
    assert_equal "http://catalog.data.gov/", kitten_data.fields["listing"]
    assert_equal "samerights", kitten_data.fields["contentRights"]
    assert_equal ["list"], kitten_data.fields["versionManagement"]
    assert_equal "http://catalog.data.gov/api/rest/package/some_data", kitten_data.fields["versionsUrl"]
    assert_equal "http://www.data.gov/issue/?media_url=http://catalog.data.gov/some_data", kitten_data.fields["improvementsContact"]
  end

  test 'data.gov assumptions are set for federal organizations with no license information when automatic' do
    set_us_data
    DataKitten::Dataset.any_instance.stubs(:licenses).returns([])
    @kitten_data = KittenData.new(url: 'http://catalog.data.gov/some_data', automatic: true)

    assert_equal "true", kitten_data.fields["usGovData"]
    assert_equal "cc_zero", kitten_data.fields["internationalDataLicence"]
    assert kitten_data.assumed_us_public_domain?
  end

  test 'data.gov only gov data assumption is set for federal organizations with no license information when not automatic' do
    set_us_data
    license = DataKitten::License.new(id: 'us-pd')
    DataKitten::Dataset.any_instance.stubs(:licenses).returns([license])
    @kitten_data = KittenData.new(url: 'http://catalog.data.gov/some_data')

    assert_equal "true", kitten_data.fields["usGovData"]
    assert_nil kitten_data.fields["internationalDataLicence"]
    refute kitten_data.assumed_us_public_domain?
  end

  test 'assumed_us_public_domain does not crash on old kitten data instances' do
    #kitten_data = KittenData.new(url: 'http://catalog.data.gov/some_data')
    kitten_data.data = false # old versions stored false instead of {}
    refute kitten_data.assumed_us_public_domain?
  end

  %w[us-pd other-pd notspecified].each do |license_id|
    test "data.gov assumptions are set for federal organizations with #{license_id} license" do
      set_us_data
      license = DataKitten::License.new(id: license_id)
      DataKitten::Dataset.any_instance.stubs(:licenses).returns([license])
      @kitten_data = KittenData.new(url: 'http://catalog.data.gov/some_data', automatic: true)

      assert_equal "true", kitten_data.fields["usGovData"]
      assert_equal "cc_zero", kitten_data.fields["internationalDataLicence"]
      assert kitten_data.assumed_us_public_domain?
    end
  end

  test 'data.gov assumptions are not set for non-federal organizations' do
    set_us_data("City Government")
    @kitten_data = KittenData.new(url: 'http://catalog.data.gov/some_data')

    assert_nil kitten_data.fields["internationalDataLicence"]
  end

  test 'Distribution metadata is set correctly' do
    DataKitten::DistributionFormat.any_instance.stubs('open?').returns(true)
    DataKitten::DistributionFormat.any_instance.stubs('structured?').returns(true)

    assert_equal "true", kitten_data.fields["machineReadable"]
    assert_equal "true", kitten_data.fields["openStandard"]
  end

  test 'Correct metadata fields are set when data is present' do
    metadata = [
      "title",
      "description",
      "identifier",
      "landingPage",
      "accrualPeriodicity",
      "publisher",
      "keyword",
      "theme",
      "distribution",
      "issued",
      "modified",
      "temporal",
      "spatial",
      "language"
    ]

    assert_equal metadata, kitten_data.fields["documentationMetadata"]
  end

  test 'No metadata fields are set when data is not present' do
    set_blank_data

    assert_equal nil, kitten_data.fields["documentationMetadata"]
  end

  test 'Correct distribution metadata fields are set with one distribution' do
    metadata = [
      "title",
      "description",
      "issued",
      "modified",
      "accessURL",
      "downloadURL",
      "byteSize",
      "mediaType"
    ]

    assert_equal metadata, kitten_data.fields["distributionMetadata"]
  end

  test 'Correct distribution metadata fields are set with multiple distributions' do
    distributions = [{
      title: "title 1",
      accessURL: "http://example.org/dataset",
      byteSize: nil
    }, {
      title: "title 2",
      accessURL: nil,
      byteSize: 1000
    }].map do |fields|
      distribution = DataKitten::Distribution.new(self, {})
      fields.each { |key,value| distribution.stubs(key).returns(value) }
      distribution
    end

    DataKitten::Dataset.any_instance.stubs(:distributions).returns(distributions)

    assert_equal ["title"], kitten_data.fields["distributionMetadata"]
  end

  test 'No distribution metadata fields are set with no distributions' do
    set_blank_data

    assert_equal nil, kitten_data.fields["distributionMetadata"]
  end

  test 'Codelist is detected when present' do
    source = {
      "codelist" => [{ "url" => "http://example.org/codelist", "name" => "codelist" }]
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)

    assert_equal "true", kitten_data.fields["codelists"]
    assert_equal "http://example.org/codelist", kitten_data.fields["codelistDocumentationUrl"]
  end

  test 'Schema is detected when present for the dataset' do
    source = {
      "schema" => [{ "url" => "http://example.org/schema.json", "name" => "schema" }]
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)

    assert_equal "true", kitten_data.fields["vocabulary"]
  end

  test 'Schema is detected when present for one of the resources' do
    source = {
      "resources" => [{ "schema-url" => "http://example.org/schema.json" }]
    }
    DataKitten::Dataset.any_instance.stubs(:source).returns(source)

    assert_equal "true", kitten_data.fields["vocabulary"]
  end

  test "accessor to data attributes returns nil on non serialzed kitten data" do
    kd = KittenData.new
    kd.data = false
    assert_equal nil, kd.get(:title)
  end

  test "accessor to data attributes" do
    kd = KittenData.new
    kd.data = {
      :title => "testing title",
      :empty => nil,
    }

    assert_equal "testing title", kd.get(:title)
    assert_equal nil, kd.get(:empty)
    assert_equal nil, kd.get(:missing)
  end

  test "accessor to data attributes that are lists" do
    publisher = DataKitten::Agent.new(mbox: 'hi@example.org')
    kd = KittenData.new
    kd.data = {
      :publishers => [publisher],
      :maintainers => nil
    }

    assert_equal [publisher], kd.get_list(:publishers)
    assert_equal [], kd.get_list(:maintainers)
  end
end
