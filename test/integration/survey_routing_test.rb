require_relative '../test_helper'

class SurveyRoutingTest < ActionDispatch::IntegrationTest

  test "redirects old survey URL that includes :survey_code" do
    response_set = FactoryGirl.create(:response_set)

    get "/en/surveys/gb/#{response_set.access_code}/take"

    assert_redirected_to "/en/surveys/#{response_set.access_code}/take"
  end

end
