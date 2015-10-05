require_relative '../test_helper'

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
    assert_redirected_to "/en/datasets/#{cert.response_set.dataset.id}/certificates/#{cert.id}"
  end

  test "certificate embed URL redirects" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get "/certificates/#{cert.id}/embed"
    assert_response :redirect
    assert_redirected_to "/en/datasets/#{cert.response_set.dataset.id}/certificates/#{cert.id}/embed"
  end

  test "certificate badge URL redirects" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get "/certificates/#{cert.id}/badge"
    assert_response :redirect
    assert_redirected_to "/en/datasets/#{cert.response_set.dataset.id}/certificates/#{cert.id}/badge"
  end

  test "user edit URL redirects" do
    user = FactoryGirl.create(:user)
    post_via_redirect '/users/sign_in', "user[email]" => user.email, "user[password]" => 'testpassword'
    assert_response :success
    get "/users/edit"
    assert_response :redirect
    assert_redirected_to "/users/#{user.id}/edit?locale=en"
  end

  context "certificate from dataset URL" do

    setup do
      @cert = FactoryGirl.create(:published_certificate_with_dataset)
    end

    should "redirect to the certificate page if no type is specified" do
       get "/en/datasets?datasetUrl=http://www.example.com"
       assert_response :redirect
       assert_redirected_to "/en/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}"
    end

    should "redirect to the embed page if embed type is specified" do
      get "/en/datasets/embed?datasetUrl=http://www.example.com"
      assert_response :redirect
      assert_redirected_to "/en/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}/embed"
    end

    should "redirect to the badge if badge type is specified" do
      get "/en/datasets/badge?datasetUrl=http://www.example.com"
      assert_response :redirect
      assert_redirected_to "/en/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}/badge"
    end

    should "preserve the format if a format is specified" do
      get "/en/datasets.json?datasetUrl=http://www.example.com"
      assert_response :redirect
      assert_redirected_to "/en/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}.json"

      get "/en/datasets/badge.js?datasetUrl=http://www.example.com"
      assert_response :redirect
      assert_redirected_to "/en/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}/badge.js"
    end

  end

end
