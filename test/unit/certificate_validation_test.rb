require 'test_helper'

class CertificateValidationTest < ActiveSupport::TestCase

  test "should not save without user" do
    cv = FactoryGirl.build :certificate_validation, user: nil
    assert !cv.save
  end

  test "should not save without certificate" do
    cv = FactoryGirl.build :certificate_validation, certificate: nil
    assert !cv.save
  end

  test "user can't validate their own certificate" do
    cv = FactoryGirl.build :certificate_validation
    cv.user = cv.certificate.user

    assert !cv.save
  end

end
