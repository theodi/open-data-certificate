require 'test_helper'

class VerificationTest < ActiveSupport::TestCase

  test "should not save without user" do
    cv = FactoryGirl.build :verification, user: nil
    assert !cv.save
  end

  test "should not save without certificate" do
    cv = FactoryGirl.build :verification, certificate: nil
    assert !cv.save
  end

  test "user can't validate their own certificate" do
    cv = FactoryGirl.build :verification
    cv.user = cv.certificate.user

    assert !cv.save
  end

  test "a certificate can't be validated multiple times by the same user" do
    cv = FactoryGirl.create :verification

    cv2 = FactoryGirl.build :verification, 
                             user: cv.user, certificate: cv.certificate
    assert !cv2.save

  end

end
