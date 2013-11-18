require 'test_helper'

class CertificateTest < ActiveSupport::TestCase

  def setup
    Certificate.destroy_all

    @certificate1 = FactoryGirl.create(:response_set_with_dataset).certificate
    @certificate2 = FactoryGirl.create(:response_set_with_dataset).certificate
    @certificate3 = FactoryGirl.create(:response_set_with_dataset).certificate

    @certificate1.update_attributes(name: 'Banana certificate', curator: 'John Smith')
    @certificate2.update_attributes(name: 'Monkey certificate', curator: 'John Wards')
    @certificate3.update_attributes(name: 'Monkey banana certificate', curator: 'Frank Smith')

    @certificate1.response_set.survey.update_attributes(full_title: 'United Kingdom')
    @certificate2.response_set.survey.update_attributes(full_title: 'United States')
    @certificate3.response_set.survey.update_attributes(full_title: 'Wales')
  end

  test 'search title matches single term' do
    assert_equal [@certificate1, @certificate3], Certificate.search_title('banana')
  end

  test 'search title matches multiple terms' do
    assert_equal [@certificate3], Certificate.search_title('certificate Monkey banana')
  end

  test 'search publisher matches single term' do
    assert_equal [@certificate1, @certificate2], Certificate.search_publisher('JOHN')
  end

  test 'search publisher matches multiple terms' do
    assert_equal [@certificate3], Certificate.search_publisher('Frank Smith')
  end

  test 'search country matches single term' do
    assert_equal [@certificate1, @certificate2], Certificate.search_country('United')
  end

  test 'search country matches multiple terms' do
    assert_equal [@certificate1], Certificate.search_country('United Kingdom')
  end

  test 'verified by user' do
    cv = FactoryGirl.create(:verification)
    user2 = FactoryGirl.create(:user)

    assert cv.certificate.verified_by_user? cv.user
    refute cv.certificate.verified_by_user? user2
  end

  test 'certification_type' do
    certificate = FactoryGirl.create(:response_set_with_dataset).certificate

    assert_equal :self, certificate.certification_type,
                        'defaults to self certified'

    2.times do
      FactoryGirl.create :verification, certificate: certificate
    end

    assert_equal :community, certificate.certification_type,
                             'community certifified when verified by 2 users'

  end
end
