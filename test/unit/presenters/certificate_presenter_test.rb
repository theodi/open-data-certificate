require 'test_helper'

class CertificatePresenterTest < ActiveSupport::TestCase

  def setup
    Certificate.destroy_all

    @certificate = FactoryGirl.create(:response_set_with_dataset).certificate
    @certificate.update_attributes(name: 'Banana certificate', curator: 'John Smith')
    @certificate.response_set.survey.update_attributes(full_title: 'United Kingdom')
  end

  test "published_data returns the correct hash" do
    presenter = CertificatePresenter.new(@certificate).published_data

    assert_equal "Banana certificate", presenter[:name]
    assert_equal "John Smith", presenter[:publisher]
    assert_match /test[0-9]+@example\.com/, presenter[:user]
    assert_equal "alpha", presenter[:type]
    assert_equal "exemplar", presenter[:level]
    assert_equal :self, presenter[:verification_type]
  end

  test "all_data returns the correct hash" do
    presenter = CertificatePresenter.new(@certificate).all_data

    assert_equal "Banana certificate", presenter[:name]
    assert_equal "John Smith", presenter[:publisher]
    assert_equal " ", presenter[:user_name]
    assert_match /test[0-9]+@example\.com/, presenter[:user_email]
    assert_equal "Simple survey", presenter[:country]
    assert_equal "draft", presenter[:status]
    assert_equal "exemplar", presenter[:level]
  end

end
