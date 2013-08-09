require 'test_helper'

class RedirectsTest < ActionDispatch::IntegrationTest

  test "dashboard URL redirects" do
    get "/dashboard"
    assert_response :redirect
    assert_redirected_to '/users/dashboard'
  end
  
  test "certificate URL redirects" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get "/certificates/#{cert.id}"
    assert_response :redirect
    assert_redirected_to "/datasets/#{cert.response_set.dataset.id}/certificates/#{cert.id}"
  end
  
  test "certificate embed URL redirects" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get "/certificates/#{cert.id}/embed"
    assert_response :redirect
    assert_redirected_to "/datasets/#{cert.response_set.dataset.id}/certificates/#{cert.id}/embed"
  end

  test "certificate badge URL redirects" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get "/certificates/#{cert.id}/badge"
    assert_response :redirect
    assert_redirected_to "/datasets/#{cert.response_set.dataset.id}/certificates/#{cert.id}/badge"
  end
  
  test "user edit URL redirects" do
    user = FactoryGirl.create(:user)
    post_via_redirect '/users/sign_in', "user[email]" => user.email, "user[password]" => 'testpassword'
    assert_response :success
    get "/users/edit"
    assert_response :redirect
    assert_redirected_to "/users/#{user.id}/edit"
  end

end
