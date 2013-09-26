require 'test_helper'

class TransfersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "user should create transfer" do
    user = FactoryGirl.create :user
    sign_in user

    dataset = FactoryGirl.create :dataset, user: user
    transfer = FactoryGirl.build :transfer, dataset: dataset

    assert_difference 'Transfer.count', 1 do
      post :create, transfer: transfer.attributes
    end

    assert_redirected_to '/users/dashboard'

    assert_equal 'Transfer created', flash[:notice]
    assert_equal user, assigns(:transfer).user
  end

  test "user can't transfer a dataset they don't own" do
    user = FactoryGirl.create :user
    sign_in user

    other_user = FactoryGirl.create :user
    dataset = FactoryGirl.create :dataset, user: other_user
    transfer = FactoryGirl.build :transfer, dataset: dataset

    assert_no_difference 'Transfer.count' do
      assert_raises CanCan::AccessDenied do
        post :create, transfer: transfer.attributes
      end
    end
  end

  test "should get claim" do
    transfer = FactoryGirl.create :transfer
    get :claim, id: transfer.id
    assert_response :success
  end
end
