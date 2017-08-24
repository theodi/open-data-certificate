require_relative '../test_helper'

class TransferMailerTest < ActionMailer::TestCase

  test "transfer notify" do
    transfer = FactoryGirl.create :transfer

    email = TransferMailer.notify(transfer).deliver

    refute ActionMailer::Base.deliveries.empty?

    assert_equal [transfer.target_email], email.to
    assert_equal "certificates", email.header["X-MC-Subaccount"].value

    assert_match "/transfers/#{transfer.id}/claim?token=#{transfer.token}", email.body.to_s
  end

end
