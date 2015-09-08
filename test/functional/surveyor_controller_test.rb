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

  test "continue with expired survey" do
    @response_set = FactoryGirl.create(:response_set)
    @response_set.certificate.update_attribute :expires_at, DateTime.now - 1.day
    sign_in @response_set.user

    assert_no_difference('ResponseSet.count') do
      post :continue, use_route: :surveyor,
              survey_code: @response_set.survey.access_code,
              response_set_code: @response_set.access_code,
              update: true
    end

    assert_redirected_to "/surveys/#{@response_set.survey.access_code}/#{@response_set.access_code}/take?update=true"

  end

  test "continue with superceeded survey" do
    @response_set = FactoryGirl.create(:response_set)

    # a new version of the survey is added
    FactoryGirl.create(:survey,
      access_code: @response_set.survey.access_code,
      survey_version: @response_set.survey.survey_version + 1
    )

    sign_in @response_set.user

    assert_difference('ResponseSet.count', 1) do
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

  test "updating a response_set is published if it was from an update to an already published response set" do
    @response_set = FactoryGirl.create(:response_set)

    sign_in @response_set.user

    post :update, use_route: :surveyor,
                  survey_code: @response_set.survey.access_code,
                  response_set_code: @response_set.access_code,
                  update: true # this indicates it was previously published

    @response_set.reload
    assert_equal true, ResponseSet.last.published?

    assert_redirected_to dashboard_url
  end

  test "continue migrated questionnaire" do
    @surveyOld = FactoryGirl.create(:survey, access_code: 'open-data-certificate-questionnaire')
    @surveyNew = FactoryGirl.create(:survey, access_code: 'gb')

    @response_set = FactoryGirl.create(:response_set, survey: @surveyOld)
    sign_in @response_set.user

    assert_difference 'ResponseSet.count', 1 do
      post :continue, use_route: :surveyor,
              survey_code: @response_set.survey.access_code,
              response_set_code: @response_set.access_code
    end

    r = ResponseSet.last
    assert_equal r.survey.access_code, 'gb'
    assert_redirected_to "/surveys/#{r.survey.access_code}/#{r.access_code}/take"

  end

  test "continue survey with highlighed question" do
    @response_set = FactoryGirl.create(:response_set)
    sign_in @response_set.user

    assert_no_difference('ResponseSet.count') do
      post :continue, use_route: :surveyor,
              survey_code: @response_set.survey.access_code,
              response_set_code: @response_set.access_code,
              question: 123
    end

    assert_redirected_to "/surveys/#{@response_set.survey.access_code}/#{@response_set.access_code}/take#q_123"
  end

  test "continue a completed questionnaire with highlighted question" do
    @response_set = FactoryGirl.create(:response_set)
    @response_set.update_attribute :aasm_state, 'archived'

    sign_in @response_set.user

    assert_difference 'ResponseSet.count', 1 do
      post :continue, use_route: :surveyor,
              survey_code: @response_set.survey.access_code,
              response_set_code: @response_set.access_code,
              question: 123
    end

    r = ResponseSet.last
    assert_redirected_to "/surveys/#{r.survey.access_code}/#{r.access_code}/take#q_123"
  end

  test "start page" do
    ResponseSet.any_instance.stubs(:documentation_url_explanation).returns(nil)
    @response_set = FactoryGirl.create(:response_set)
    survey = @response_set.survey
    section = FactoryGirl.create(:survey_section)
    survey.sections << section
    question = FactoryGirl.create(:question, reference_identifier: "documentationUrl", survey_section: section)
    question.answers << FactoryGirl.create(:answer) 

    sign_in @response_set.user

    get :start, use_route: :surveyor,
            survey_code: @response_set.survey.access_code,
            response_set_code: @response_set.access_code

    assert_response 200
  end

  test "404s if response_set does not exist" do
    FactoryGirl.create(:survey, access_code: 'gb')

    get :edit, use_route: :surveyor,
      survey_code: "gb",
      response_set: "nope"

    assert_response :not_found
  end

  test "repeater field fragment" do
    question = FactoryGirl.create(:question, question_group: FactoryGirl.create(:question_group, display_type: 'repeater'))
    survey = question.survey_section.survey

    response_set = FactoryGirl.create(:response_set, survey: survey)
    sign_in response_set.user

    get :repeater_field, use_route: :surveyor,
      survey_code: 'gb',
      response_set_code: response_set.access_code,
      question_id: question.id,
      response_index: 1, # these numbers seem to not matter ¬_¬
      response_group: 0

    assert_response :ok
  end

end
