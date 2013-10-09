require 'test_helper'

class TransferMailerTest < ActionMailer::TestCase

  test "transfer notify" do
    transfer = FactoryGirl.create :transfer

    email = TransferMailer.notify(transfer).deliver

    refute ActionMailer::Base.deliveries.empty?

    assert_equal [transfer.target_email], email.to

    assert_match "/transfers/#{transfer.id}/claim?token=#{transfer.token}", email.body
  end

end
