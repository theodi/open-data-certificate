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
    assert_equal "", presenter[:user_name]
    assert_match /test[0-9]+@example\.com/, presenter[:user_email]
    assert_equal "Simple survey", presenter[:country]
    assert_equal "draft", presenter[:status]
    assert_equal "exemplar", presenter[:level]
  end

  test "all data status is expired if past expiry date" do
    @certificate.expires_at = 1.month.ago
    presenter = CertificatePresenter.new(@certificate).all_data
    assert_equal 'expired', presenter[:status]
  end

  test "gives blank user_name for no associated user" do
    presenter = CertificatePresenter.new(@certificate).all_data
    assert_equal "", presenter[:user_name]
  end

  test "constructs user_name from user association" do
    @certificate.user = FactoryGirl.create(:user, :name => "Joan Jett")
    presenter = CertificatePresenter.new(@certificate).all_data
    assert_equal "Joan Jett", presenter[:user_name]
  end

  test "gives N/A if user email blank" do
    @certificate.user.email = " "
    presenter = CertificatePresenter.new(@certificate).published_data
    assert_equal "N/A", presenter[:user]
  end

  test "orphaned if response_set is blank" do
    @certificate.response_set.destroy
    pub_data = CertificatePresenter.new(@certificate).published_data
    all_data = CertificatePresenter.new(@certificate).all_data
    assert_equal "orphaned certificate", pub_data[:country]
    assert_equal "orphaned certificate", all_data[:country]
  end
end
