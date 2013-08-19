require 'test_helper'

class JurisdictionsControllerTest < ActionController::TestCase
  test "should get index" do

    FactoryGirl.create :survey, title: "GB", access_code: "GB", full_title: "United Kingdoom", survey_version: 0
    FactoryGirl.create :survey, title: "GB", access_code: "GB", full_title: "United Kingdom", survey_version: 1
    FactoryGirl.create :survey, title: "AD", access_code: "AD", full_title: "Andorra"

    get :index, use_route: :surveyor
    assert_response :success

    assert_equal 2, assigns(:jurisdictions).size

  end

end
