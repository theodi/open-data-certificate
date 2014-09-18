require 'test_helper'

class DatasetTest < ActiveSupport::TestCase

  test "Should set the title if it hasn't been set before" do
    dataset = FactoryGirl.create(:untitled_dataset)
    dataset.set_default_title!('Test dataset default title')
    dataset.reload

    assert_equal(dataset.title, 'Test dataset default title')
  end

  test "Should overwrite the title if it has been set before" do
    dataset = FactoryGirl.create(:dataset, title: 'Test original title')
    assert_equal(dataset.title, 'Test original title')
    dataset.reload

    dataset.set_default_title!('Test dataset default title')
    dataset.reload

    assert_equal(dataset.title, 'Test dataset default title')
  end

  test "Should set the documentation URL if it hasn't been set before" do
    dataset = FactoryGirl.create(:dataset_without_documentation_url)
    dataset.set_default_documentation_url!('http://foo.com')
    dataset.reload

    assert_equal(dataset.documentation_url, 'http://foo.com')
  end

  test "Should overwrite the documentation URL if it has been set before" do
    dataset = FactoryGirl.create(:dataset, documentation_url: 'http://foo.com')
    assert_equal(dataset.documentation_url, 'http://foo.com')
    dataset.reload

    dataset.set_default_documentation_url!('http://foo.com/bar')
    dataset.reload

    assert_equal(dataset.documentation_url, 'http://foo.com/bar')
  end

  test "#newest_response_set should return the most recent response set" do

    dataset = FactoryGirl.create(:dataset, documentation_url: 'http://foo.com')
    survey = FactoryGirl.create(:survey)
    response_set_1 = FactoryGirl.create(:response_set, survey: survey, dataset: dataset)
    response_set_2 = FactoryGirl.create(:response_set, survey: survey, dataset: dataset)

    dataset.reload

    assert_equal(dataset.newest_response_set, response_set_2)
  end

  test "#newest_completed_response_set should return the most recent response set completed" do
    dataset = FactoryGirl.create(:dataset, documentation_url: 'http://foo.com')
    survey = FactoryGirl.create(:survey)
    response_set_1 = FactoryGirl.create(:response_set, survey: survey, dataset: dataset)
    completed_response_set_2 = FactoryGirl.create(:completed_response_set, survey: survey, dataset: dataset)
    completed_response_set_3 = FactoryGirl.create(:completed_response_set, survey: survey, dataset: dataset)
    response_set_4 = FactoryGirl.create(:response_set, survey: survey, dataset: dataset)

    dataset.reload

    assert_equal(dataset.newest_completed_response_set, completed_response_set_3)
  end

  test "#destroy_if_no_responses should not destroy the dataset if the response_sets is not empty" do

    dataset = FactoryGirl.create(:dataset, documentation_url: 'http://foo.com')
    response_set = FactoryGirl.create(:response_set, dataset: dataset)
    dataset.reload

    dataset.destroy_if_no_responses

    dataset = Dataset.find_by_id(dataset.id)

    refute_nil(dataset)
  end

  test "#destroy_if_no_responses should destroy the dataset if the response_sets is empty"  do

    dataset = FactoryGirl.create(:dataset, documentation_url: 'http://foo.com')

    dataset.reload

    dataset.destroy_if_no_responses
    dataset = Dataset.find_by_id(dataset.id)
    assert_nil(dataset)
  end

  test "#response_set should give the published dataset" do

    dataset = FactoryGirl.create(:dataset)

    FactoryGirl.create_list(:response_set, 10, dataset: dataset)

    active = dataset.response_sets[5]
    active.publish!

    assert_equal active, dataset.response_set
  end

  test "#certificate should give the published certificate" do

    dataset = FactoryGirl.create(:dataset)

    FactoryGirl.create_list(:response_set, 10, dataset: dataset)

    active = dataset.response_sets[5]
    active.publish!

    assert_equal active.certificate, dataset.certificate
  end

  test "removed is false by default and not mass-assignable" do
    dataset = FactoryGirl.create(:dataset)
    dataset.update_attributes({removed: true})

    refute dataset.removed
  end

  test 'creates an embed stat' do
    dataset = FactoryGirl.create(:dataset)
    dataset.register_embed("http://example.com/page")

    assert_equal 1, EmbedStat.all.count
    assert_equal dataset, EmbedStat.first.dataset
  end

  test 'creates one embed stat per URL through dataset' do
    2.times do |i|
      dataset = FactoryGirl.create(:dataset)
      5.times { dataset.register_embed("http://example.com/page") }
    end

    assert_equal 2, EmbedStat.all.count
  end

  test 'get results of autopublished certificate' do
    load_custom_survey 'cert_generator.rb'
    user = FactoryGirl.create :user
    survey = Survey.newest_survey_for_access_code 'cert-generator'

    request = {
      jurisdiction: 'cert-generator',
      dataset: {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example.com',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    CertificateGenerator.create(request: request, survey: survey, user: user).generate(false)
    response = Dataset.last.generation_result

    assert_equal(true, response[:success])
    assert_equal(true, response[:published])
    assert_equal(user.email, response[:owner_email])
    assert_equal([], response[:errors])
  end

  test 'get results of certificate with missing field' do
    load_custom_survey 'cert_generator.rb'
    user = FactoryGirl.create :user
    survey = Survey.newest_survey_for_access_code 'cert-generator'

    request = {
      jurisdiction: 'cert-generator',
      dataset: {
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example.com',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    CertificateGenerator.create(request: request, survey: survey, user: user).generate(false)
    response = Dataset.last.generation_result

    assert_equal(true, response[:success])
    assert_equal(false, response[:published])
    assert_equal(["The question 'dataTitle' is mandatory"], response[:errors])
  end

  test 'get results of certificate with invalid URL' do
    load_custom_survey 'cert_generator.rb'
    user = FactoryGirl.create :user
    survey = Survey.newest_survey_for_access_code 'cert-generator'

    stub_request(:get, "http://www.example/error").
        to_return(:body => "", status: 404)

    request = {
      jurisdiction: 'cert-generator',
      dataset: {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example/error',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    CertificateGenerator.create(request: request, survey: survey, user: user).generate(false)
    response = Dataset.last.generation_result

    assert_equal(true, response[:success])
    assert_equal(false, response[:published])
    assert_equal(["The question 'publisherUrl' must have a valid URL"], response[:errors])
  end

  test 'doesn\'t show results when generation hasn\'t happened' do
    load_custom_survey 'cert_generator.rb'
    user = FactoryGirl.create :user
    survey = Survey.newest_survey_for_access_code 'cert-generator'

    request = {
      jurisdiction: 'cert-generator',
      dataset: {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example.com',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    cert = CertificateGenerator.create(request: request, survey: survey, user: user)
    response = Dataset.last.generation_result

    assert_equal("pending", response[:success])

    cert.generate(false)
    response = Dataset.last.generation_result

    assert_equal(true, response[:success])
    assert_equal(true, response[:published])
    assert_equal(user.email, response[:owner_email])
    assert_equal([], response[:errors])
  end

end
