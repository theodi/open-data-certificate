require_relative '../test_helper'

class ClaimsMailerTest < ActionMailer::TestCase

  test "claim notify" do
    claim = FactoryGirl.create :claim_on_published_certificate

    email = ClaimMailer.notify(claim).deliver

    refute ActionMailer::Base.deliveries.empty?

    assert_equal [Devise.mailer_sender], email.to
    assert_equal "certificates", email.header["X-MC-Subaccount"].value
  end

  test "claim notiy owning user if set to send to owners" do
    claim = FactoryGirl.create :claim_on_published_certificate

    silence_warnings { Claim::DELIVERY_ADMIN_OVERRIDE = false }
    email = ClaimMailer.notify(claim).deliver
    silence_warnings { Claim::DELIVERY_ADMIN_OVERRIDE = true }

    refute ActionMailer::Base.deliveries.empty?

    assert_equal [claim.user.email], email.to
    assert_equal "certificates", email.header["X-MC-Subaccount"].value
  end

  test "claim denial notification" do
    claim = FactoryGirl.create :claim_on_published_certificate

    email = ClaimMailer.notify_of_denial(claim).deliver

    refute ActionMailer::Base.deliveries.empty?

    assert_equal [claim.initiating_user.email], email.to
    assert_equal "certificates", email.header["X-MC-Subaccount"].value
  end

  test "claim approval notification" do
    claim = FactoryGirl.create :claim_on_published_certificate

    email = ClaimMailer.notify_of_approval(claim).deliver

    refute ActionMailer::Base.deliveries.empty?

    assert_equal [claim.initiating_user.email], email.to
    assert_equal "certificates", email.header["X-MC-Subaccount"].value
  end

end
