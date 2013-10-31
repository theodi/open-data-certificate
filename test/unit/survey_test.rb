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

  test "#previous_surveys returns all surveys with the same access code" do
    survey1 = FactoryGirl.create :survey
    survey2 = FactoryGirl.create :survey, access_code: survey1.access_code, survey_version: nil
    survey3 = FactoryGirl.create :survey, access_code: survey1.access_code, survey_version: nil

    assert survey1.previous_surveys.length == 0
    assert survey2.previous_surveys.length == 1
    assert survey3.previous_surveys.length == 2
  end

  test "#set_expired_certificates sets expires at field if the status has been incremented" do
    survey1 = FactoryGirl.create :survey, status: 'alpha'
    survey2 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'alpha', survey_version: nil
    survey3 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'beta', survey_version: nil
    survey4 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'final', survey_version: nil

    certificate1 = FactoryGirl.create :certificate, response_set: FactoryGirl.create(:response_set, survey: survey1)
    certificate2 = FactoryGirl.create :certificate, response_set: FactoryGirl.create(:response_set, survey: survey2)
    certificate3 = FactoryGirl.create :certificate, response_set: FactoryGirl.create(:response_set, survey: survey3)
    certificate4 = FactoryGirl.create :certificate, response_set: FactoryGirl.create(:response_set, survey: survey4)

    now = DateTime.now

    survey2.set_expired_certificates

    assert certificate1.reload.expires_at == nil
    assert certificate2.reload.expires_at == nil
    assert certificate3.reload.expires_at == nil
    assert certificate4.reload.expires_at == nil

    survey3.set_expired_certificates

    assert certificate1.reload.expires_at > now
    assert certificate2.reload.expires_at > now
    assert certificate3.reload.expires_at == nil
    assert certificate4.reload.expires_at == nil
  end

  test "#set_expired_certificates only sets the expiry date once" do
    survey1 = FactoryGirl.create :survey, status: 'alpha'
    survey2 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'beta', survey_version: nil
    survey3 = FactoryGirl.create :survey, access_code: survey1.access_code, status: 'final', survey_version: nil

    certificate = FactoryGirl.create :certificate, response_set: FactoryGirl.create(:response_set, survey: survey1)

    survey2.set_expired_certificates

    expiry = certificate.reload.expires_at
    assert expiry != nil

    survey3.set_expired_certificates

    assert certificate.reload.expires_at == expiry
  end
end
