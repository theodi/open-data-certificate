require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = FactoryGirl.create :user
    @admin = FactoryGirl.create :user

    ENV['ODC_ADMIN_IDS'] = "#{@admin.id}"
  end

  test "cannot be accessed by normal user" do
    assert_raises(CanCan::AccessDenied) do
      sign_in @user
      get :index
    end
  end

  test "can be accessed by admin user" do
    sign_in @admin
    get :index

    assert_response 200
  end

end
