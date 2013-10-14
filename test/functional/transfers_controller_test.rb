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
    assert_equal "/transfers/#{transfer.id}/claim", session[:sign_in_redirect]
  end

  test "accept claim" do
    sign_in user = FactoryGirl.create(:user)
    transfer = FactoryGirl.create :notified_transfer, target_email: user.email

    assert_difference ->{user.reload.datasets.count}, 1 do
      put :accept, id: transfer.id, transfer: {token_confirmation: transfer.token} 
    end

    assert_redirected_to '/users/dashboard'
    assert_equal I18n.t('transfers.flashes.complete'), flash[:notice]
    assert transfer.reload.accepted?

  end

  test "accept claim fails without token confirmation" do
    sign_in user = FactoryGirl.create(:user)
    transfer = FactoryGirl.create :notified_transfer, target_email: user.email

    put :accept, id: transfer.id

    assert_equal I18n.t('transfers.flashes.access_denied_token'), flash[:error]
    refute transfer.reload.accepted?
  end

  test "accept claim fails without matching user email" do
    sign_in user = FactoryGirl.create(:user)
    transfer = FactoryGirl.create :notified_transfer, target_email: "foo+#{user.email}"

    put :accept, id: transfer.id, transfer: {token_confirmation: transfer.token} 

    assert_equal I18n.t('transfers.flashes.access_denied_email'), flash[:error]
    refute transfer.reload.accepted?
  end

  test "accepting user can't override the target_email" do
    sign_in user = FactoryGirl.create(:user)
    transfer = FactoryGirl.create :notified_transfer, target_email: "foo+#{user.email}"

    put :accept, id: transfer.id, transfer: {token_confirmation: transfer.token, target_email: user.email} 

    assert_equal I18n.t('transfers.flashes.access_denied'), flash[:error]
    refute transfer.reload.accepted?

  end


  test "user can destroy a transfer they initiated" do
    transfer = FactoryGirl.create :transfer
    sign_in transfer.user

    assert_difference 'Transfer.count', -1 do
      put :destroy, id: transfer.id
    end

    assert flash[:error].nil?
  end

  test "user can't destroy a transfer they did not initiate" do
    transfer = FactoryGirl.create :transfer
    sign_in FactoryGirl.create(:user)

    assert_no_difference 'Transfer.count' do
      put :destroy, id: transfer.id
    end

    assert_equal I18n.t('transfers.flashes.access_denied'), flash[:error]
  end

end