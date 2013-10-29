require 'test_helper'

class SurveyTest < ActiveSupport::TestCase

  test "#superceded? returns false when survey is most recent version" do
    survey = FactoryGirl.create :survey # version 0
    survey = FactoryGirl.create :survey, access_code: survey.access_code, survey_version: nil # version 1

    assert Survey.newest_survey_for_access_code(survey.access_code).try(:survey_version) == 1
    assert_false survey.superceded?
  end

  test "#superceded? returns true when survey is not most recent version" do
    survey = FactoryGirl.create :survey # version 0
    survey = FactoryGirl.create :survey, access_code: survey.access_code, survey_version: nil # version 1
    FactoryGirl.create :survey, access_code: survey.access_code, survey_version: nil # version 2

    assert Survey.newest_survey_for_access_code(survey.access_code).try(:survey_version) == 2
    assert survey.superceded?
  end

  test "#status_incremented? returns true when the previous survey has a lower status" do
    survey1 = FactoryGirl.create :survey, status: 'alpha'
    survey2 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'beta', survey_version: nil
    survey3 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'final', survey_version: nil

    assert survey2.status_incremented?
    assert survey3.status_incremented?
  end

  test "#status_incremented? returns false when the previous survey doesn't have a lower status" do
    survey1 = FactoryGirl.create :survey, status: 'beta'
    survey2 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'beta', survey_version: nil
    survey3 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'alpha', survey_version: nil

    assert_false survey1.status_incremented?
    assert_false survey2.status_incremented?
    assert_false survey3.status_incremented?
  end

  test "#all_survey_versions returns all surveys with the same access code" do
    survey1 = FactoryGirl.create :survey
    survey2 = FactoryGirl.create :survey, access_code: survey1.access_code, survey_version: nil
    survey3 = FactoryGirl.create :survey, access_code: survey1.access_code, survey_version: nil

    assert survey1.all_survey_versions.length == 3
    assert survey2.all_survey_versions.length == 3
    assert survey3.all_survey_versions.length == 3
  end

  test "#schedule_expiries sets expires at field if the status has been incremented" do
    survey1 = FactoryGirl.create :survey, status: 'alpha'
    survey2 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'alpha', survey_version: nil

    response_set1 = FactoryGirl.create :response_set, survey: survey1
    response_set2 = FactoryGirl.create :response_set, survey: survey1
    response_set3 = FactoryGirl.create :response_set, survey: survey2

    now = DateTime.now

    survey2.schedule_expiries

    assert response_set1.reload.expires_at == nil
    assert response_set2.reload.expires_at == nil
    assert response_set3.reload.expires_at == nil

    survey3 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'beta', survey_version: nil
    survey3.schedule_expiries

    assert response_set1.reload.expires_at > now
    assert response_set2.reload.expires_at > now
    assert response_set3.reload.expires_at > now
  end
end
