require_relative '../test_helper'

class UserManagementTest < ActionDispatch::IntegrationTest

  setup do
    user = FactoryGirl.create(:user, preferred_locale: 'cs')
    post_via_redirect '/users/sign_in', "user[email]" => user.email, "user[password]" => 'testpassword'
  end

  test "user is redirected to their preferred locale after update" do
    post '/users', preferred_locale: 'en'
    assert_redirected_to dashboard_path(locale: 'en')
  end

end
