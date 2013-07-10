require 'test_helper'

class SurveyorControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "continue survey" do
    @response_set = FactoryGirl.create(:response_set)
    sign_in @response_set.user

    assert_no_difference('ResponseSet.count') do
      post :continue, use_route: :surveyor, 
              survey_code: @response_set.survey.access_code, 
              response_set_code: @response_set.access_code
    end

    assert_redirected_to "/surveys/#{@response_set.survey.access_code}/#{@response_set.access_code}/take"

  end


  test "continue with superceeded survey" do
    @response_set = FactoryGirl.create(:response_set)

    # a new version of the survey is added
    FactoryGirl.create(:survey, 
      access_code: @response_set.survey.access_code, 
      survey_version: @response_set.survey.survey_version + 1
    )

    sign_in @response_set.user

    # TODO: deal with superseded response sets properly, losing the record isn't very cool
    # assert_difference('ResponseSet.count', 1) do
    assert_no_difference 'ResponseSet.count' do
      post :continue, use_route: :surveyor, 
              survey_code: @response_set.survey.access_code, 
              response_set_code: @response_set.access_code
    end

    # redirected to the new survey
    r = ResponseSet.last
    assert_not_equal @response_set, r
    assert_redirected_to "/surveys/#{r.survey.access_code}/#{r.access_code}/take"

  end


  test "continue a completed questionnaire" do 
    @response_set = FactoryGirl.create(:response_set)
    @response_set.update_attribute :aasm_state, 'archived'

    sign_in @response_set.user
    
    assert_difference 'ResponseSet.count', 1 do
      post :continue, use_route: :surveyor, 
              survey_code: @response_set.survey.access_code, 
              response_set_code: @response_set.access_code
    end

    r = ResponseSet.last
    assert_redirected_to "/surveys/#{r.survey.access_code}/#{r.access_code}/take"

  end

end
