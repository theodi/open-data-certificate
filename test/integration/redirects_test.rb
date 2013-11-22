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
  
  context "latest certificate URL" do
    
    setup do
      @cert = FactoryGirl.create(:published_certificate_with_dataset)
    end
    
    should "redirect to the correct certificate" do
      get "/datasets/#{@cert.response_set.dataset.id}/certificates/latest"
      
      assert_response :redirect
      assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}"
    end
    
    should "redirect to the correct badge" do
      get "/datasets/#{@cert.response_set.dataset.id}/certificates/latest/badge"
      
      assert_response :redirect
      assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}/badge"
    end
    
    should "redirect to the correct embed page" do
      get "/datasets/#{@cert.response_set.dataset.id}/certificates/latest/embed"
      
      assert_response :redirect
      assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}/embed"
    end
    
    should "preserve the format when redirecting" do
      get "/datasets/#{@cert.response_set.dataset.id}/certificates/latest.json"
      
      assert_response :redirect
      assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}.json"
      
      get "/datasets/#{@cert.response_set.dataset.id}/certificates/latest/badge.js"
      
      assert_response :redirect
      assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}/badge.js"
    end
    
  end
  
  context "certificate from dataset URL" do
    
    setup do
      @cert = FactoryGirl.create(:published_certificate_with_dataset)
    end
    
    should "redirect to the certificate page if no type is specified" do
       get "/datasets?datasetUrl=http://www.example.com"
       assert_response :redirect
       assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}"
    end
    
    should "redirect to the embed page if embed type is specified" do
      get "/datasets/embed?datasetUrl=http://www.example.com"
      assert_response :redirect
      assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}/embed"
    end

    should "redirect to the badge if badge type is specified" do
      get "/datasets/badge?datasetUrl=http://www.example.com"
      assert_response :redirect
      assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}/badge"
    end
    
    should "preserve the format if a format is specified" do
      get "/datasets.json?datasetUrl=http://www.example.com"
      assert_response :redirect
      assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}.json"
      
      get "/datasets/badge.js?datasetUrl=http://www.example.com"
      assert_response :redirect
      assert_redirected_to "/datasets/#{@cert.response_set.dataset.id}/certificates/#{@cert.id}/badge.js"
    end
    
  end

end
