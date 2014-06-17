require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "user is an admin if id is in the env var" do
    @user1 = FactoryGirl.create :user
    @user2 = FactoryGirl.create :user
    @user3 = FactoryGirl.create :user

    ENV['ODC_ADMIN_IDS'] = "#{@user1.id},#{@user3.id}"

    assert @user1.admin?, 'user one is admin'
    refute @user2.admin?, 'user two is not admin'
    assert @user3.admin?, 'user three is admin'

    ENV['ODC_ADMIN_IDS'] = nil
  end

  test "has_expired_or_expiring_certificates? returns false if user's certificates are up to date" do
    user = FactoryGirl.create(:user)

    5.times do
       FactoryGirl.create(:response_set_with_dataset, user: user, aasm_state: "published")
    end

    assert_equal false, user.has_expired_or_expiring_certificates?
  end

  test "has_expired_or_expiring_certificates? returns true if user has expiring certificates" do
    user = FactoryGirl.create(:user)

    5.times do
       FactoryGirl.create(:response_set_with_dataset, user: user, aasm_state: "published")
    end

    certificate = Certificate.last
    certificate.expires_at =  DateTime.now + 1.day
    certificate.save

    assert_equal true, user.has_expired_or_expiring_certificates?
  end

  test "has_expired_or_expiring_certificates? returns true if the user has expired certificates" do
    user = FactoryGirl.create(:user)

    5.times do
       FactoryGirl.create(:response_set_with_dataset, user: user, aasm_state: "published")
    end

    certificate = Certificate.last
    certificate.expires_at =  DateTime.now - 1.day
    certificate.save

    assert_equal true, user.has_expired_or_expiring_certificates?
  end

  test "has_expired_or_expiring_certificates? returns false if a user has an unpublished expiring certificate" do
    user = FactoryGirl.create(:user)

    5.times do
       FactoryGirl.create(:response_set_with_dataset, user: user, aasm_state: "published")
    end

    FactoryGirl.create(:response_set_with_dataset, user: user, aasm_state: "draft")

    certificate = Certificate.last
    certificate.expires_at =  DateTime.now - 1.day
    certificate.save

    assert_equal false, user.has_expired_or_expiring_certificates?
  end

end
