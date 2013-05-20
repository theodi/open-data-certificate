require 'test_helper'

class UserDatasetsTest < ActionDispatch::IntegrationTest

  def setup
    @user = FactoryGirl.create(:user)
    @survey = FactoryGirl.create(:survey)
  end

  test "user logs in and create dataset" do
    # sign_in user
    post '/users/sign_in', :user => {:email => @user.email, :password => @user.password, :remember_me => 0}

    # dataset is linked to the user
    assert_difference lambda { @user.datasets.count } do
      post '/datasets', :dataset => {title: 'my dataset' }
    end
  end

  test "user creates a survey, then logs in and the survey is assigned to them" do

    assert_difference lambda { ResponseSet.count } do
      post '/surveys', :survey_access_code => @survey.access_code
    end

    assert_not_nil(session[:response_set_id])

    response_set = ResponseSet.find(session[:response_set_id])

    assert_not_nil(response_set)

    post '/users/sign_in', :user => {:email => @user.email, :password => @user.password, :remember_me => 0}

    assert_difference lambda { @user.response_sets.count } do
      put "/surveys/#{@survey.access_code}/#{response_set.access_code}"
    end

    assert_nil(session[:response_set_id])
  end

  def teardown
    @user.destroy
    @survey.destroy
  end

end
