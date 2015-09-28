require_relative '../test_helper'

class UserTest < ActiveSupport::TestCase

  test "user is an admin if db column set" do
    @user1 = FactoryGirl.create :user, :admin => true
    @user2 = FactoryGirl.create :user
    @user3 = FactoryGirl.create :user, :admin => true

    assert @user1.admin?, 'user one is admin'
    refute @user2.admin?, 'user two is not admin'
    assert @user3.admin?, 'user three is admin'
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

  test "identifier defaults to name" do
    user = FactoryGirl.create(:user, :name => "I'm the batman")
    assert_equal "I'm the batman", user.identifier
  end

  test "identifier uses email as sentence if no name" do
    user = FactoryGirl.create(:user, :email => "bob@example.com")
    assert_equal "bob from example.com", user.identifier
  end

  test "greeting is short name" do
    user = FactoryGirl.create(:user, :short_name => "Jeff")
    assert_equal "Jeff", user.greeting
  end

  test "greeting falls back to name" do
    user = FactoryGirl.create(:user, :name => "Joan Jett")
    assert_equal "Joan Jett", user.greeting
  end

  test "greeting falls further back to email prefix" do
    user = FactoryGirl.create(:user, :email => "sally@example.com")
    assert_equal "sally", user.greeting
  end

  test "to_s defaults to email" do
    user = FactoryGirl.create(:user, :email => "sally@example.com")
    assert_equal "sally@example.com", user.to_s
  end

  test "to_s uses name and email" do
    user = FactoryGirl.create(:user, :email => "joan@example.com", :name => "Joan Jett")
    assert_equal "Joan Jett <joan@example.com>", user.to_s
  end

  test "can create a user without specifying agreement to terms" do
    assert User.new(email: 'robyn@example.com', password: 'password').valid?
  end

  test "can create a user that agreeds to terms" do
    assert User.new(email: 'robyn@example.com', password: 'password', agreed_to_terms: true).valid?
  end

  test "not agreeing to terms prevents saving" do
    refute User.new(email: 'robyn@example.com', password: 'password', agreed_to_terms: false).valid?
  end

end
