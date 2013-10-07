require 'test_helper'

class TransferTest < ActiveSupport::TestCase

  def setup
    Delayed::Job.destroy_all
  end

  test "notifying target user" do
    transfer = FactoryGirl.create :transfer

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      transfer.notify
      (Delayed::Worker.new).work_off 1
    end

    assert transfer.notified?
  end

  test "transfer has a hex token when created" do
    transfer = FactoryGirl.create :transfer

    refute transfer.token.blank?
  end
end
