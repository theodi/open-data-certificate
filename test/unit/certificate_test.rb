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

    assert_equal 3, Certificate.published.count
  end

  test "status returns the expected status" do
    @certificate1.publish!
    assert_equal @certificate1.status, "published"

    @certificate1.draft!
    assert_equal @certificate1.status, "draft"
  end

  test "certificate counts return the correct counts" do
    @certificate1.update_attributes(published: false)
    @certificate2.update_attributes(published: true)
    @certificate3.update_attributes(published: true)

    @certificate2.update_attributes(attained_level: "pilot")
    @certificate3.update_attributes(attained_level: "standard")

    counts = Certificate.counts

    assert_equal 3, counts[:all]
    assert_equal 3, counts[:all_this_month]
    assert_equal 2, counts[:published]
    assert_equal 2, counts[:published_this_month]
    assert_equal 0, counts[:levels][:basic]
    assert_equal 1, counts[:levels][:pilot]
    assert_equal 1, counts[:levels][:standard]
    assert_equal 0, counts[:levels][:expert]
  end

  test 'days_to_expiry returns correct number of days' do
    @certificate1.expires_at = DateTime.now + 14
    @certificate1.save

    assert_equal 14, @certificate1.days_to_expiry
  end

  test 'publishing certificate sets published date' do
    certificate = FactoryGirl.create(:response_set_with_dataset).certificate
    certificate.publish!

    assert_equal Date.today, certificate.published_at.to_date
  end

  test 'publishing certificate through aasm sets published state sucessfully' do
    certificate = FactoryGirl.create(:response_set_with_dataset).certificate
    certificate.publish!

    assert certificate.published
  end

end
