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

  test "#show_all should return all published datasets which have a response set and certificate" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end
    5.times do
      FactoryGirl.create(:certificate_with_dataset)
    end

    datasets = Dataset.show_all

    assert_equal 5, datasets.count
  end

  test "#multi_search should search by certificate name" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end

    FactoryGirl.create(:published_certificate_with_dataset, name: "Banana Certificate")

    search = Dataset.multi_search("Banana")

    assert_equal 1, search.count
    assert_equal "Banana Certificate", search.first.certificate.name
  end

  test "#multi_search should search by curator name" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end

    FactoryGirl.create(:published_certificate_with_dataset, curator: "Banana Phone")

    search = Dataset.multi_search("Banana")

    assert_equal 1, search.count
    assert_equal "Banana Phone", search.first.certificate.curator
  end

  test "#multi_search should search by survey name" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end
    survey = FactoryGirl.create(:survey, full_title: "My cool survey")
    FactoryGirl.create(:published_certificate_with_dataset, survey: survey)

    search = Dataset.multi_search("cool")

    assert_equal 1, search.count
    assert_equal survey, search.first.certificate.survey
  end

end
