require 'test_helper'

class ClaimsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "creating a claim on a dataset" do
    owner = FactoryGirl.create(:user)
    initiating_user = FactoryGirl.create(:user)
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    dataset = certificate.dataset
    dataset.change_owner!(owner)

    sign_in initiating_user
    post :create, :claim => {:dataset_id => dataset.id}

    claim = Claim.last
    assert_not_nil claim
    assert_equal initiating_user, claim.initiating_user
    assert_equal dataset, claim.dataset
    assert_equal certificate.user, owner

    assert_redirected_to dataset_certificate_path(dataset, certificate)
    assert_equal I18n.t('claims.flashes.created'), flash[:notice]
    job = Delayed::Job.last.payload_object
    assert_equal claim, job.object
    assert_equal :notify_without_delay!, job.method_name
  end

  test "creating a claim without being logged in" do
    owner = FactoryGirl.create(:user)
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    dataset = certificate.dataset
    dataset.change_owner!(owner)

    post :create, :claim => {:dataset_id => dataset.id}
    assert_redirected_to new_user_session_path
  end

  test "listing outstanding claims" do
    owner = FactoryGirl.create(:user)
    FactoryGirl.create_list(:claim_on_published_certificate, 4, user: owner)
    FactoryGirl.create_list(:claim_on_published_certificate, 2)

    sign_in owner
    get :index

    assert_response :ok
    assert_equal 4, assigns(:outstanding_claims).size
  end

  test "listing outstanding claims to admin" do
    admin = FactoryGirl.create(:admin_user)
    FactoryGirl.create_list(:claim_on_published_certificate, 3)

    sign_in admin
    get :index

    assert_response :ok
    assert_equal 3, assigns(:outstanding_claims).size
  end

  test "approving claim" do
    owner = FactoryGirl.create(:user)
    initiating_user = FactoryGirl.create(:user)
    claim = FactoryGirl.create(:claim_on_published_certificate, user: owner, initiating_user: initiating_user)
    dataset = claim.dataset

    sign_in owner
    assert_equal owner, dataset.user
    post :approve, :id => claim.id
    assert_redirected_to claims_path

    assert :accepted, claim.reload.aasm_state
    assert_equal initiating_user, dataset.reload.user
  end

  test "approving claim as another user fails" do
    owner = FactoryGirl.create(:user)
    initiating_user = FactoryGirl.create(:user)
    claim = FactoryGirl.create(:claim_on_published_certificate, user: owner, initiating_user: initiating_user)
    dataset = claim.dataset

    sign_in initiating_user
    assert_equal owner, dataset.user
    post :approve, :id => claim.id

    assert :new, claim.reload.aasm_state
    assert_equal owner, dataset.reload.user
  end

  test "denying claim" do
    owner = FactoryGirl.create(:user)
    initiating_user = FactoryGirl.create(:user)
    claim = FactoryGirl.create(:claim_on_published_certificate, user: owner, initiating_user: initiating_user)
    dataset = claim.dataset

    sign_in owner
    assert_equal owner, dataset.user
    post :deny, :id => claim.id

    assert :denied, claim.reload.aasm_state
    assert_equal owner, dataset.reload.user
  end

  test "denying claim as another user fails" do
    owner = FactoryGirl.create(:user)
    initiating_user = FactoryGirl.create(:user)
    claim = FactoryGirl.create(:claim_on_published_certificate, user: owner, initiating_user: initiating_user)
    dataset = claim.dataset

    sign_in initiating_user
    assert_equal owner, dataset.user
    post :deny, :id => claim.id

    assert :new, claim.reload.aasm_state
    assert_equal owner, dataset.reload.user
  end
end
