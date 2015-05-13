require 'test_helper'
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
      d.access_url = 'http://example.com/distribution'
      d.extension = 'txt'
      d.format = DataKitten::DistributionFormat.new(d)
    end

    publisher = DataKitten::Agent.new({})
    publisher.tap do |p|
      p.name = 'test_name'
      p.homepage = 'http://example.com/homepage'
      p.mbox = 'test_contact'
    end

    rights = DataKitten::Rights.new({})
    rights.tap do |r|
      r.uri = 'http://example.com/rights'
      r.dataLicense = "http://opendatacommons.org/licenses/pddl/"
      r.contentLicense = "http://creativecommons.org/licenses/by/2.0/uk/"
    end

    license = DataKitten::License.new({})
    license.uri = "http://opendatacommons.org/licenses/by/"

    temporal = DataKitten::Temporal.new({})
    temporal.tap do |t|
      t.start = Date.new
      t.end = Date.new
    end

    data = {
      data_title: 'test_title',
      description: 'test_description',
      publishers: [publisher],
      rights: rights,
      licenses: [license],
      update_frequency: 'test_frequency',
      keywords: ['test', 'unit'],
      issued: Date.new,
      modified: Date.new,
      temporal: temporal,
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
      publishers: nil,
      rights: nil,
      licenses: nil,
      update_frequency: nil,
      keywords: nil,
      issued: nil,
      modified: nil,
      temporal: nil,
      distributions: nil
    }

    data.each do |key, value|
      DataKitten::Dataset.any_instance.stubs(key).returns(value)
    end
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
      access_url: 'http://example.com/distribution',
      open: nil,
      extension: :txt,
      structured: nil
    }]

    assert_equal 'test_title', kitten_data.data[:title]
    assert_equal 'test_description', kitten_data.data[:description]
    assert_equal 1, kitten_data.data[:publishers].length
    assert_kind_of DataKitten::Agent, kitten_data.data[:publishers][0]
    assert_kind_of DataKitten::Rights, kitten_data.data[:rights]
    assert_equal 1, kitten_data.data[:licenses].length
    assert_kind_of DataKitten::License, kitten_data.data[:licenses][0]
    assert_equal 'test_frequency', kitten_data.data[:update_frequency]
    assert_equal ['test', 'unit'], kitten_data.data[:keywords]
    assert_kind_of Date, kitten_data.data[:release_date]
    assert_kind_of Date, kitten_data.data[:modified_date]
    assert_kind_of DataKitten::Temporal, kitten_data.data[:temporal_coverage]
    assert_equal distributions, kitten_data.data[:distributions]
  end

  test 'Nil data is extracted from Data Kitten in the correct format' do
    set_minimum_data

    assert_equal 'test', kitten_data.data[:title]
    assert_equal '', kitten_data.data[:description]
    assert_equal [], kitten_data.data[:publishers]
    assert_nil kitten_data.data[:rights]
    assert_equal [], kitten_data.data[:licenses]
    assert_equal '', kitten_data.data[:update_frequency]
    assert_equal [], kitten_data.data[:keywords]
    assert_nil kitten_data.data[:release_date]
    assert_nil kitten_data.data[:modified_date]
    assert_kind_of DataKitten::Temporal, kitten_data.data[:temporal_coverage]
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

  test 'Release type is detected as a one off' do
    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns(nil)

    assert_equal 'oneoff', kitten_data.fields["releaseType"]
  end

  test 'Dataset URL is detected correctly' do
    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns(nil)

    assert_equal 'http://example.com/distribution', kitten_data.fields["datasetUrl"]
  end

  test 'Release type is detected as a collection' do
    distribution = DataKitten::Distribution.new(self, {})
    distribution.format = DataKitten::DistributionFormat.new(distribution)

    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns(nil)
    DataKitten::Dataset.any_instance.stubs(:distributions).returns([distribution, distribution])

    assert_equal 'collection', kitten_data.fields["releaseType"]
  end

  test 'Release type is detected as a series' do
    distribution = DataKitten::Distribution.new(self, {})
    distribution.format = DataKitten::DistributionFormat.new(distribution)

    DataKitten::Dataset.any_instance.stubs(:distributions).returns([distribution, distribution])

    assert_equal 'series', kitten_data.fields["releaseType"]
  end

  test 'Release type is detected as a service' do
    DataKitten::Dataset.any_instance.stubs(:update_frequency).returns(nil)
    DataKitten::Dataset.any_instance.stubs(:description).returns('This is an API')

    assert_equal 'service', kitten_data.fields["releaseType"]
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
    DataKitten::Dataset.any_instance.stubs(:licenses).returns([license])
    DataKitten::Dataset.any_instance.stubs(:rights).returns(nil)

    assert_equal "yes", kitten_data.fields["publisherRights"]
    assert_equal "ogl_uk", kitten_data.fields["dataLicence"]
    assert_equal "ogl_uk", kitten_data.fields["contentLicence"]
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
    stub_request(:get, 'http://data.gov.uk/some_crazy_data').to_return(status: 200)
    @kitten_data = KittenData.new(url: 'http://data.gov.uk/some_crazy_data')

    assert_equal "true", kitten_data.fields["publisherOrigin"]
    assert_equal "not_personal", kitten_data.fields["dataPersonal"]
    assert_equal "false", kitten_data.fields["frequentChanges"]
    assert_equal "false", kitten_data.fields["vocabulary"]
    assert_equal "false", kitten_data.fields["codelists"]
    assert_equal kitten_data.url, kitten_data.fields["copyrightURL"]
    assert_equal "true", kitten_data.fields["listed"]
    assert_equal "http://data.gov.uk", kitten_data.fields["listing"]
    assert_equal "samerights", kitten_data.fields["contentRights"]
    assert_equal ["list"], kitten_data.fields["versionManagement"]
    assert_equal "http://data.gov.uk/api/rest/package/some_crazy_data", kitten_data.fields["versionsUrl"]
  end

  test 'data.london.gov.uk assumptions are applied' do
    stub_request(:get, 'http://data.london.gov.uk/some_data').to_return(status: 200)
    @kitten_data = KittenData.new(url: 'http://data.london.gov.uk/some_data')

    assert_equal "true", kitten_data.fields["publisherOrigin"]
    assert_equal "not_personal", kitten_data.fields["dataPersonal"]
    assert_equal "false", kitten_data.fields["frequentChanges"]
    assert_equal "false", kitten_data.fields["vocabulary"]
    assert_equal "false", kitten_data.fields["codelists"]
    assert_equal kitten_data.url, kitten_data.fields["copyrightURL"]
    assert_equal "true", kitten_data.fields["listed"]
    assert_equal "http://data.london.gov.uk", kitten_data.fields["listing"]
    assert_equal "samerights", kitten_data.fields["contentRights"]
    assert_equal ["list"], kitten_data.fields["versionManagement"]
    assert_equal "http://data.london.gov.uk/api/rest/package/some_data", kitten_data.fields["versionsUrl"]
  end

  test 'data.gov assumptions are applied' do
    stub_request(:get, 'http://catalog.data.gov/some_data').to_return(status: 200)
    @kitten_data = KittenData.new(url: 'http://catalog.data.gov/some_data')

    assert_equal "true", kitten_data.fields["publisherOrigin"]
    assert_equal "not_personal", kitten_data.fields["dataPersonal"]
    assert_equal "false", kitten_data.fields["frequentChanges"]
    assert_equal "false", kitten_data.fields["vocabulary"]
    assert_equal "false", kitten_data.fields["codelists"]
    assert_equal kitten_data.url, kitten_data.fields["copyrightURL"]
    assert_equal "true", kitten_data.fields["listed"]
    assert_equal "http://catalog.data.gov", kitten_data.fields["listing"]
    assert_equal "samerights", kitten_data.fields["contentRights"]
    assert_equal ["list"], kitten_data.fields["versionManagement"]
    assert_equal "http://catalog.data.gov/api/rest/package/some_data", kitten_data.fields["versionsUrl"]
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
      "accrualPeriodicity",
      "publisher",
      "keyword",
      "distribution",
      "issued",
      "modified",
      "temporal"
    ]

    assert_equal metadata, kitten_data.fields["documentationMetadata"]
  end

  test 'No metadata fields are set when data is not present' do
    set_blank_data

    assert_equal nil, kitten_data.fields["documentationMetadata"]
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
