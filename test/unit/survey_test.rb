require 'test_helper'

class SurveyTest < ActiveSupport::TestCase

  test "#superceded? returns false when survey is most recent version" do
    survey = FactoryGirl.create :survey # version 0
    survey = FactoryGirl.create :survey, access_code: survey.access_code, survey_version: nil # version 1

    assert Survey.newest_version_for_access_code(survey.access_code) == 1
    assert_false survey.superceded?
  end

  test "#superceded? returns true when survey is not most recent version" do
    survey = FactoryGirl.create :survey # version 0
    survey = FactoryGirl.create :survey, access_code: survey.access_code, survey_version: nil # version 1
    FactoryGirl.create :survey, access_code: survey.access_code, survey_version: nil # version 2

    assert Survey.newest_version_for_access_code(survey.access_code) == 2
    assert survey.superceded?
  end


end
