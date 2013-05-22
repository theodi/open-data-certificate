require 'test_helper'

class DatasetTest < ActiveSupport::TestCase

  test "Should set the title if it hasn't been set before" do
    dataset = FactoryGirl.create(:untitled_dataset)
    dataset.set_default_title!('Test dataset default title')
    dataset.reload

    assert_equal(dataset.title, 'Test dataset default title')
  end

  test "Shouldn't set the title if it has been set before" do
    dataset = FactoryGirl.create(:dataset)
    dataset.set_default_title!('Test dataset default title')
    dataset.reload

    assert_not_equal(dataset.title, 'Test dataset default title')
  end
end
