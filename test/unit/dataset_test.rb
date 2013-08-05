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
end
