require 'test_helper'

class ResponseSetTest < ActiveSupport::TestCase

  should belong_to(:dataset)
  should have_one(:certificate)

  test "creating a response set does not a certificate" do
    assert_no_difference "Certificate.count" do
      FactoryGirl.create :response_set
    end
  end

  test "completing a response set creates a certificate" do
    assert_difference "Certificate.count" do
      FactoryGirl.create :completed_response_set
    end
  end

  test "created certificate is given the attained_level" do
    rs = FactoryGirl.create :completed_response_set
    assert_equal rs.certificate.attained_level, rs.attained_level
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


  test "#incomplete! should mark completed response_sets as incomplete" do
    response_set = FactoryGirl.create :completed_response_set

    assert response_set.complete?

    response_set.incomplete!
    response_set.reload

    assert_false response_set.complete?
    assert_nil response_set.completed_at
  end

  test "#triggered_mandatory_questions should return an array of all the mandatory questions that are triggered by their dependencies for the response_set" do
    # non-mandatory question
    question = FactoryGirl.create(:question, is_mandatory: false)

    survey_section = question.survey_section
    survey = survey_section.survey

    # mandatory question, but not triggered
    mandatory_question = FactoryGirl.create(:question, is_mandatory: true, survey_section: survey_section)
    dependency = FactoryGirl.create(:dependency, question: mandatory_question)
    FactoryGirl.create :dependency_condition, dependency: dependency, operator: 'count>2'

    # triggered mandatory question
    triggered_mandatory_question = FactoryGirl.create(:question, is_mandatory: true, survey_section: survey_section)
    survey.reload

    response_set = FactoryGirl.create(:response_set, survey: survey)

    assert_equal response_set.triggered_mandatory_questions, [triggered_mandatory_question]
  end

  test "#triggered_requirements should return an array of all the requirements that are triggered by their dependencies for the response_set" do
    survey_section = FactoryGirl.create(:survey_section)
    survey = survey_section.survey

    # non-triggered requirement
    question = FactoryGirl.create(:question, requirement: 'level_1', survey_section: survey_section)
    requirement = FactoryGirl.create(:requirement, requirement: 'level_1', survey_section: survey_section)
    dependency = FactoryGirl.create(:dependency, question: requirement)
    FactoryGirl.create :dependency_condition, question: question, dependency: dependency, operator: 'count>2'

    # non-triggered requirement
    question = FactoryGirl.create(:question, requirement: 'level_2', survey_section: survey_section)
    requirement = FactoryGirl.create(:requirement, requirement: 'level_2', survey_section: survey_section)
    dependency = FactoryGirl.create(:dependency, question: requirement)
    FactoryGirl.create :dependency_condition, question: question, dependency: dependency, operator: 'count>2'

    # triggered requirement
    question = FactoryGirl.create(:question, requirement: 'level_3', survey_section: survey_section)
    requirement = FactoryGirl.create(:requirement, requirement: 'level_3', survey_section: survey_section)
    dependency = FactoryGirl.create(:dependency, question: requirement)
    FactoryGirl.create :dependency_condition, question: question, dependency: dependency, operator: 'count<2'
    survey.reload

    response_set = FactoryGirl.create(:response_set, survey: survey)

    assert_equal response_set.triggered_requirements, [requirement]
  end

  test "#attained_level returns the correct string for the level achieved" do
    %w(none basic pilot standard exemplar).each_with_index do |level, i|
      response_set = FactoryGirl.create(:response_set)
      response_set.stubs(:minimum_outstanding_requirement_level).returns(i+1)
      assert_equal response_set.attained_level, level
    end
  end

  test "#minimum_outstanding_requirement_level returns correct value" do
    requirements = []
    Hash[*%w(5 exemplar 4 standard 3 pilot 2 basic 1 none)].each do |k, v|
      response_set = FactoryGirl.create(:response_set)
      requirements << stub(requirement_level_index: k.to_i)
      response_set.stubs(:outstanding_requirements).returns(requirements)
      assert_equal response_set.minimum_outstanding_requirement_level, k.to_i
    end
  end

  test "#minimum_outstanding_requirement_level returns exemplar index if there's no outstanding requirements" do
    response_set = FactoryGirl.create(:response_set)
    assert_equal response_set.minimum_outstanding_requirement_level, 5
  end

  test "#completed_requirements returns only triggered_requirements that are met by responses" do
    triggered_requirements = [ stub(requirement: 'level_1', requirement_met_by_responses?: true),
                               stub(requirement: 'level_2', requirement_met_by_responses?: false),
                               stub(requirement: 'level_3', requirement_met_by_responses?: false),
                               stub(requirement: 'level_4', requirement_met_by_responses?: false),
                               ]

    response_set = FactoryGirl.create(:response_set)
    response_set.stubs(:triggered_requirements).returns(triggered_requirements)

    assert_equal [triggered_requirements.first], response_set.completed_requirements
  end

  test "#outstanding_requirements returns only triggered_requirements that are not met by responses" do
    triggered_requirements = [ stub(requirement: 'level_1', requirement_met_by_responses?: true),
                               stub(requirement: 'level_2', requirement_met_by_responses?: true),
                               stub(requirement: 'level_3', requirement_met_by_responses?: true),
                               stub(requirement: 'level_4', requirement_met_by_responses?: false),
    ]

    response_set = FactoryGirl.create(:response_set)
    response_set.stubs(:triggered_requirements).returns(triggered_requirements)

    assert_equal [triggered_requirements.last], response_set.outstanding_requirements
  end

end
