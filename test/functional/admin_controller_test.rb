require_relative '../test_helper'

class AdminControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = FactoryGirl.create :user
    @admin = FactoryGirl.create :admin_user
  end

  test "cannot be accessed by normal user" do
    sign_in @user
    get :index

    assert_response 403
  end

  test "can be accessed by admin user" do
    sign_in @admin
    get :index

    assert_response 200
  end

  test "ordinary user cannot admin a user" do
    sign_in @user
    get :users, user_id: @user.id

    assert_response 403
  end

  test "admin can admin a usr" do
    sign_in @admin
    get :users, user_id: @user.id

    assert_response 200
  end

  test "only admin can search users" do
    sign_in @user
    get :typeahead, q: "q"

    assert_response 403
  end

  test "user search finds by email fragment" do
    sign_in @admin
    get :typeahead, q: @user.email.split('@').first

    body = JSON.parse(@response.body)
    assert_equal([{
        'user' => @user.to_s,
        'value' => @user.email,
        'path' => admin_users_path(@user)
      }],
      body)
  end

end
