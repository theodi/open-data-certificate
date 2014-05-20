require 'test_helper'

class MainControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "homepage" do
    get :home
    assert_response 200
  end

  test "has_js" do
    get :has_js
    assert_response 200
    assert_equal session[:surveyor_javascript], 'enabled'
  end

  # survey creating has been moved into the application controller

  def setup
    @survey_other        = FactoryGirl.create :survey, access_code: 'other'
    @survey_user_default = FactoryGirl.create :survey, access_code: 'user_default'
    @survey_app_default  = FactoryGirl.create :survey, access_code: 'gb'
  end

  test "start_questionnaire with app default jurisdiction" do

    post :start_questionnaire
    assert assigns(:response_set).survey == @survey_app_default

  end

  test "start_questionnaire with user default_jurisdiction set" do

    sign_in FactoryGirl.create(:user, default_jurisdiction: 'user_default')
    post :start_questionnaire
    assert assigns(:response_set).survey == @survey_user_default

  end

  test "start_questionnaire with custom param" do

    post :start_questionnaire, survey_access_code: 'other'
    assert assigns(:response_set).survey == @survey_other

  end

  test "start_questionnaire entities belongs to user" do
    sign_in @user = FactoryGirl.create(:user)

    post :start_questionnaire
    assert_equal assigns(:response_set).user_id, @user.id, "response set belongs to user"
    assert_equal assigns(:dataset).user_id, @user.id, "dataset belongs to user"
  end

end
