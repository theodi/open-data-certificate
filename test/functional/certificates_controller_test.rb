require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "unpublished certificates can't be shown" do
    cert = FactoryGirl.create(:certificate)
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, {id: cert.id}
    end
  end

  test "certificates can be shown" do
    cert = FactoryGirl.create(:published_certificate)
    get :show, {id: cert.id}
    assert_response :success
  end


  test "other" do
    assert false
  end

end
