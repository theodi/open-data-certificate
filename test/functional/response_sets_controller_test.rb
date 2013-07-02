require 'test_helper'

class ResponseSetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "user can destroy their response_set" do
    @user = FactoryGirl.create(:user)
    @response_set = FactoryGirl.create(:response_set, :user => @user)

    sign_in @user

    assert_difference('ResponseSet.count', -1) do
      delete :destroy, use_route: :surveyor, id: @response_set.id
    end

    assert_redirected_to dashboard_path

  end


  test "another user can't destroy response_set" do
    @response_set = FactoryGirl.create(:response_set)

    # unconnected user
    sign_in FactoryGirl.create(:user)

    assert_no_difference('ResponseSet.count') do
      delete :destroy, use_route: :surveyor, id: @response_set.id
    end

    assert_response 304

  end


  test "user can publish their response_set" do
    @user = FactoryGirl.create(:user)
    @response_set = FactoryGirl.create(:response_set, :user => @user)

    sign_in @user

    post :publish, use_route: :surveyor, id: @response_set.id

    assert_redirected_to dashboard_path

    @response_set.reload
    assert @response_set.published?, "response set was published"

  end


end
