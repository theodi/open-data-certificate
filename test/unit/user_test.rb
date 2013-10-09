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

end
