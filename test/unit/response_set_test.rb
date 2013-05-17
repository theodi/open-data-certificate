require 'test_helper'

class ResponseSetTest < ActiveSupport::TestCase

  def setup
  end

  test "Should be able to populate response_set answers from another response_set" do
    response_value = rand.to_s
    q=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    a=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q)

    source_response_set = FactoryGirl.create(:response_set, survey: a.question.survey_section.survey)
    FactoryGirl.create :response, { response_set: source_response_set,
                                    string_value: response_value,
                                    answer_id: a.id,
                                    question_id: a.question.id }
    source_response_set.reload

    response_set = FactoryGirl.create :response_set, survey: source_response_set.survey
    response_set.reload

    response_set.copy_answers_from_response_set!(source_response_set)

    assert response_set.responses.first.try(:string_value) == response_value
  end


  test "Should raise an error if populating response_set answers from another response_set when responses already exist" do
    response_value = rand.to_s
    q=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    a=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q)

    source_response_set = FactoryGirl.create(:response_set, survey: a.question.survey_section.survey)
    FactoryGirl.create :response, { response_set: source_response_set,
                                    string_value: response_value,
                                    answer_id: a.id,
                                    question_id: a.question.id }
    source_response_set.reload

    response_set = FactoryGirl.create :response_set, survey: source_response_set.survey
    FactoryGirl.create :response, { response_set: response_set,
                                    string_value: 'my response',
                                    answer_id: a.id,
                                    question_id: a.question.id }
    response_set.reload

    exception = assert_raise(RuntimeError) do
      response_set.copy_answers_from_response_set!(source_response_set)
    end

    assert_equal('Attempt to over-write existing responses.', exception.message)
  end


  test "Should be able to populate response_set answers from another response_set even if the surveys are different" do
    response_value = rand.to_s
    q1=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    q2=FactoryGirl.create(:question, reference_identifier: :question_identifier)

    a1=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q1)
    a2=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q2)

    source_response_set = FactoryGirl.create(:response_set, survey: a1.question.survey_section.survey)
    FactoryGirl.create :response, { response_set: source_response_set,
                                    string_value: response_value,
                                    answer_id: a1.id,
                                    question_id: a1.question.id }
    source_response_set.reload

    response_set = FactoryGirl.create :response_set, survey: a2.question.survey_section.survey
    response_set.reload
    response_set.copy_answers_from_response_set!(source_response_set)

    assert response_set.responses.first.try(:string_value) == response_value
  end

end
