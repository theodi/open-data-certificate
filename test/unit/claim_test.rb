require 'test_helper'

class ClaimTest < ActiveSupport::TestCase
  def setup
    @dataset = FactoryGirl.create(:response_set_with_dataset).dataset
    @initiating_user = FactoryGirl.create(:user)
    @claim = Claim.create(dataset: @dataset, initiating_user: @initiating_user)
  end

  test "defaulting user to dataset owner" do
    assert_equal @dataset.user, @claim.user
  end

  test "accepting new claim" do
    @claim.accept
    assert_equal @initiating_user, @dataset.reload.user
    assert @claim.accepted?
  end

  test "accepting notified claim" do
    @claim.notify
    @claim.accept
    assert_equal @initiating_user, @dataset.reload.user
    assert @claim.accepted?
  end

  test "denying claim" do
    original_owner = @dataset.user
    @claim.deny
    assert_equal original_owner, @dataset.reload.user
    assert @claim.denied?
  end

  test "notifying dataset owner" do
    Delayed::Job.destroy_all

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      @claim.notify
      Delayed::Worker.new.work_off 1
    end

    assert @claim.notified?
  end

  test "notifying claiming user of denial" do
    Delayed::Job.destroy_all

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      @claim.deny
      Delayed::Worker.new.work_off 1
    end
  end
end
