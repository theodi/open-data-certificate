require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "Question should have :requirement attribute" do
    question = FactoryGirl.build(:question)
    assert_attribute_exists question, :requirement
  end

  test "Question should have :required attribute" do
    question = FactoryGirl.build(:question)
    assert_attribute_exists question, :required
  end

  test "Question should have :help_text_more_url attribute" do
    question = FactoryGirl.build(:question)
    assert_attribute_exists question, :help_text_more_url
  end

  test "#requirement_level should be the string from 'requirement' attribute" do
    %w(basic pilot standard exemplar).each do |level|
      question = FactoryGirl.build(:question, requirement: "#{level}_#{rand(10)}")
      assert question.requirement_level == level.to_s, "Broke with level: #{level}"
    end
  end

  test "#excluding scope should not include given records" do
    question1 = FactoryGirl.create(:question)
    question2 = FactoryGirl.create(:question)
    question3 = FactoryGirl.create(:question)

    assert_equal [question1, question3], (Question.all - Question.excluding(question1, question3))
  end

  test "#requirement_level_index should be the index at which the requirement level appears in the REQUIREMENT_LEVELS constant" do
    { basic: 1, pilot: 2, standard: 3, exemplar: 4 }.each do |level, index|
      question = FactoryGirl.build(:question, requirement: "#{level}_#{rand(10)}")
      assert question.requirement_level_index == index, "Broke with level: #{level}"
    end
  end

  test "#is_a_requirement? returns true for requirements" do
    %w(basic pilot standard exemplar).each do |level|
      question = FactoryGirl.build(:question, requirement: "#{level}_#{rand(10)}", display_type: 'label')
      assert question.is_a_requirement?
    end
  end

  test "#is_a_requirement? returns false for questions" do
    [nil, 'pilot_1'].each do |requirement|
      question = FactoryGirl.build(:question, requirement: 'pilot_1')
      assert !question.is_a_requirement?
    end
  end

  test "#question_corresponding_to_requirement should return the right question" do
    requirement = FactoryGirl.create(:question, requirement: "the_right_level_#{rand(10)}", display_type: 'label')

    rand(1..5).times { FactoryGirl.create(:question, requirement: "wrong_level_#{rand(10)}", survey_section: requirement.survey_section) } #wrong questions
    the_right_question = FactoryGirl.create(:question, requirement: requirement.requirement, survey_section: requirement.survey_section)
    rand(1..5).times { FactoryGirl.create(:question, requirement: "wrong_level_#{rand(10)}", survey_section: requirement.survey_section) } #wrong questions

    requirement.survey_section.survey.reload

    assert requirement.question_corresponding_to_requirement == the_right_question
  end

  test "#answer_corresponding_to_requirement should return the right answer" do
    requirement = FactoryGirl.create(:question, requirement: "the_right_level_#{rand(10)}", display_type: 'label')

    rand(1..5).times { FactoryGirl.create(:answer, requirement: "wrong_level_#{rand(10)}", question: FactoryGirl.create(:question, survey_section: requirement.survey_section)) } #wrong questions
    the_right_answer = FactoryGirl.create(:answer, requirement: requirement.requirement, question: FactoryGirl.create(:question, survey_section: requirement.survey_section))
    rand(1..5).times { FactoryGirl.create(:answer, requirement: "wrong_level_#{rand(10)}", question: FactoryGirl.create(:question, survey_section: requirement.survey_section)) } #wrong questions

    requirement.survey_section.survey.reload

    assert requirement.answer_corresponding_to_requirement == the_right_answer
  end

  test "for string answers - #requirement_met_by_responses? returns false when requirement is not met by responses" do
    requirement = FactoryGirl.create(:question, requirement: 'standard_1', display_type: 'label')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section)
    answer = FactoryGirl.create(:answer, requirement: requirement.requirement, question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)

    requirement.survey_section.survey.reload
    response_set.reload
    assert_false requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for string answers - #requirement_met_by_responses? returns true when requirement is met by responses" do
    requirement = FactoryGirl.create(:question, requirement: 'standard_1', display_type: 'label')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section)
    answer = FactoryGirl.create(:answer, requirement: requirement.requirement, question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer.id, string_value: 'my answer')

    requirement.survey_section.survey.reload
    response_set.reload
    assert requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for checkbox answers - #requirement_met_by_responses? returns false when requirement is not met by responses" do
    requirement = FactoryGirl.create(:question, requirement: 'standard_1', display_type: 'label')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :any)
    answer1 = FactoryGirl.create(:answer, requirement: 'basic_1', question: question)
    answer2 = FactoryGirl.create(:answer, requirement: 'pilot_1', question: question)
    answer3 = FactoryGirl.create(:answer, requirement: 'standard_1', question: question)
    answer4 = FactoryGirl.create(:answer, requirement: 'exemplar_1', question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer1.id)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer2.id)

    requirement.survey_section.survey.reload
    response_set.reload
    assert_false requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for checkbox answers - #requirement_met_by_responses? returns true when requirement is met by responses" do
    requirement = FactoryGirl.create(:question, requirement: 'standard_1', display_type: 'label')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :any)
    answer1 = FactoryGirl.create(:answer, requirement: 'basic_1', question: question)
    answer2 = FactoryGirl.create(:answer, requirement: 'pilot_1', question: question)
    answer3 = FactoryGirl.create(:answer, requirement: 'standard_1', question: question)
    answer4 = FactoryGirl.create(:answer, requirement: 'exemplar_1', question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer3.id)

    requirement.survey_section.survey.reload
    response_set.reload
    assert requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for radio answers - #requirement_met_by_responses? returns false when requirement is not met by responses" do
    requirement = FactoryGirl.create(:question, requirement: 'standard_1', display_type: 'label')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :one)
    answer1 = FactoryGirl.create(:answer, requirement: 'basic_1', question: question)
    answer2 = FactoryGirl.create(:answer, requirement: 'pilot_1', question: question)
    answer3 = FactoryGirl.create(:answer, requirement: 'standard_1', question: question)
    answer4 = FactoryGirl.create(:answer, requirement: 'exemplar_1', question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer2.id)

    requirement.survey_section.survey.reload
    response_set.reload
    assert_false requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for radio answers - #requirement_met_by_responses? returns false when requirement is met exactly by responses" do
    requirement = FactoryGirl.create(:question, requirement: 'standard_1', display_type: 'label')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :one)
    answer1 = FactoryGirl.create(:answer, requirement: 'basic_1', question: question)
    answer2 = FactoryGirl.create(:answer, requirement: 'pilot_1', question: question)
    answer3 = FactoryGirl.create(:answer, requirement: 'standard_1', question: question)
    answer4 = FactoryGirl.create(:answer, requirement: 'exemplar_1', question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer3.id)

    requirement.survey_section.survey.reload
    response_set.reload
    assert requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for radio answers - #requirement_met_by_responses? returns false when requirement is exceeded by responses" do
    requirement = FactoryGirl.create(:question, requirement: 'standard_1', display_type: 'label')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :one)
    answer1 = FactoryGirl.create(:answer, requirement: 'basic_1', question: question)
    answer2 = FactoryGirl.create(:answer, requirement: 'pilot_1', question: question)
    answer3 = FactoryGirl.create(:answer, requirement: 'standard_1', question: question)
    answer4 = FactoryGirl.create(:answer, requirement: 'exemplar_1', question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer4.id)

    requirement.survey_section.survey.reload
    response_set.reload
    assert requirement.requirement_met_by_responses?(response_set.responses)
  end
end
