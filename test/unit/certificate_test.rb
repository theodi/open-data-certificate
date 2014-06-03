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

  test 'published_certificates' do
    @certificate1.update_attributes(published: true)
    @certificate2.update_attributes(published: true)
    @certificate3.update_attributes(published: true)

    certificates = Certificate.published_certificates

    assert_equal 3, certificates.count
    assert_equal "Banana certificate", certificates.first[:name]
    assert_equal "John Smith", certificates.first[:publisher]
    assert_match /test[0-9]+@example\.com/, certificates.first[:user]
    assert_equal "alpha", certificates.first[:type]
    assert_equal "exemplar", certificates.first[:level]
    assert_equal :self, certificates.first[:verification_type]
  end

  test 'progress_by_level' do
    certificate = FactoryGirl.create(:response_set_with_dataset).certificate

    certificate.stubs(:progress).returns({
        mandatory: 3,
        mandatory_completed: 11,
        outstanding: [
          "basic_1",
          "basic_2",
          "pilot_6",
          "pilot_7",
          "pilot_8",
          "standard_11",
          "standard_12",
          "standard_13",
          "exemplar_16",
          "exemplar_18",
          "exemplar_19"
        ],
        entered: [
          "basic_3",
          "basic_4",
          "basic_5",
          "pilot_9",
          "pilot_10",
          "standard_14",
          "standard_15"
        ]
      })

    progress = certificate.progress_by_level

    assert_equal progress[:basic], 73.7
    assert_equal progress[:pilot], 66.7
    assert_equal progress[:standard], 62.1
    assert_equal progress[:exemplar], 56.3
  end

  test 'all_certificates' do
    @certificate1.update_attributes(published: false)

    all_certificates = Certificate.all_certificates
  test "status returns the expected status" do
    @certificate1.update_attributes(published: true)
    assert_equal @certificate1.status, "published"

    assert_equal 3, all_certificates.count
    assert_equal "Banana certificate", all_certificates.first[:name]
    assert_equal "John Smith", all_certificates.first[:publisher]
    assert_equal " ", all_certificates.first[:user_name]
    assert_match /test[0-9]+@example\.com/, all_certificates.first[:user_email]
    assert_equal "Simple survey", all_certificates.first[:country]
    assert_equal "draft", all_certificates.first[:status]
    assert_equal "exemplar", all_certificates.first[:level]
    @certificate1.update_attributes(published: false)
    assert_equal @certificate1.status, "draft"
  end
end
