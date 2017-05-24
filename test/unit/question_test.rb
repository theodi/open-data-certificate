require_relative '../test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "Question should have attributes we've added" do
    attributes_that_we_have_added = [:is_requirement, :corresponding_requirements, :required, :help_text_more_url]
    question = FactoryGirl.build(:question)

    attributes_that_we_have_added.each do |attribute|
      assert_attribute_exists question, attribute
    end
  end

  test "#requirement_level should be the string from 'reference_identifier' attribute" do
    %w(basic pilot standard exemplar).each do |level|
      question = FactoryGirl.build(:question, reference_identifier: "#{level}_#{rand(10)}")
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
      question = FactoryGirl.build(:question, reference_identifier: "#{level}_#{rand(10)}")
      assert question.requirement_level_index == index, "Broke with level: #{level}"
    end
  end

  test "#is_requirement? returns true for requirements" do
    %w(basic pilot standard exemplar).each do |level|
      question = FactoryGirl.build(:requirement, reference_identifier: "#{level}_#{rand(10)}")
      assert question.is_requirement?
    end
  end

  test "#is_requirement? returns false for questions" do
    [nil, 'pilot_1'].each do |requirement|
      question = FactoryGirl.build(:question, reference_identifier: 'pilot_1')
      assert !question.is_requirement?
    end
  end

  test "#question_corresponding_to_requirement should return the right question" do
    requirement = FactoryGirl.create(:requirement, reference_identifier: "the_right_level_#{rand(10)}")

    (1..5).to_a.sample.times { FactoryGirl.create(:question, corresponding_requirements: ["wrong_level_#{rand(10)}"], survey_section: requirement.survey_section) } #wrong questions
    the_right_question = FactoryGirl.create(:question, corresponding_requirements: [requirement.requirement_identifier], survey_section: requirement.survey_section)
    (1..5).to_a.sample.times { FactoryGirl.create(:question, corresponding_requirements: ["wrong_level_#{rand(10)}"], survey_section: requirement.survey_section) } #wrong questions

    requirement.survey_section.survey.reload
    requirement.save

    assert requirement.question_corresponding_to_requirement == the_right_question
  end

  test "#answer_corresponding_to_requirement should return the right answer" do
    requirement = FactoryGirl.create(:requirement, reference_identifier: "the_right_level_#{rand(10)}")

    (1..5).to_a.sample.times { FactoryGirl.create(:answer, corresponding_requirements: ["wrong_level_#{rand(10)}"], question: FactoryGirl.create(:question, survey_section: requirement.survey_section)) } #wrong questions
    the_right_answer = FactoryGirl.create(:answer, corresponding_requirements: [requirement.requirement_identifier], question: FactoryGirl.create(:question, survey_section: requirement.survey_section))
    (1..5).to_a.sample.times { FactoryGirl.create(:answer, corresponding_requirements: ["wrong_level_#{rand(10)}"], question: FactoryGirl.create(:question, survey_section: requirement.survey_section)) } #wrong questions

    requirement.survey_section.survey.reload
    requirement.save

    assert requirement.answer_corresponding_to_requirement == the_right_answer
  end

  test "for string answers - #requirement_met_by_responses? returns false when requirement is not met by responses" do
    requirement = FactoryGirl.create(:requirement, reference_identifier: 'standard_1')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section)
    answer = FactoryGirl.create(:answer, reference_identifier: requirement.requirement_identifier, question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)

    requirement.survey_section.survey.reload
    requirement.save

    response_set.reload
    assert_false requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for string answers - #requirement_met_by_responses? returns true when requirement is met by responses" do
    requirement = FactoryGirl.create(:requirement, reference_identifier: 'standard_1')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section)
    answer = FactoryGirl.create(:answer, corresponding_requirements: [requirement.requirement_identifier], question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer.id, string_value: 'my answer')

    requirement.survey_section.survey.reload
    requirement.save

    response_set.reload
    assert requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for checkbox answers - #requirement_met_by_responses? returns false when requirement is not met by responses" do
    requirement = FactoryGirl.create(:requirement, reference_identifier: 'standard_1')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :any)
    answer1 = FactoryGirl.create(:answer, corresponding_requirements: ['basic_1'], question: question)
    answer2 = FactoryGirl.create(:answer, corresponding_requirements: ['pilot_1'], question: question)
    answer3 = FactoryGirl.create(:answer, corresponding_requirements: ['standard_1'], question: question)
    answer4 = FactoryGirl.create(:answer, corresponding_requirements: ['exemplar_1'], question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer1.id)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer2.id)

    requirement.survey_section.survey.reload
    requirement.save

    response_set.reload
    assert_false requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for checkbox answers - #requirement_met_by_responses? returns true when requirement is met by responses" do
    requirement = FactoryGirl.create(:requirement, reference_identifier: 'standard_1')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :any)
    answer1 = FactoryGirl.create(:answer, corresponding_requirements: ['basic_1'], question: question)
    answer2 = FactoryGirl.create(:answer, corresponding_requirements: ['pilot_1'], question: question)
    answer3 = FactoryGirl.create(:answer, corresponding_requirements: ['standard_1'], question: question)
    answer4 = FactoryGirl.create(:answer, corresponding_requirements: ['exemplar_1'], question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer3.id)

    requirement.survey_section.survey.reload
    requirement.save

    response_set.reload
    assert requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for radio answers - #requirement_met_by_responses? returns false when requirement is not met by responses" do
    requirement = FactoryGirl.create(:requirement, reference_identifier: 'standard_1')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :one)
    answer1 = FactoryGirl.create(:answer, corresponding_requirements: ['basic_1'], question: question)
    answer2 = FactoryGirl.create(:answer, corresponding_requirements: ['pilot_1'], question: question)
    answer3 = FactoryGirl.create(:answer, corresponding_requirements: ['standard_1'], question: question)
    answer4 = FactoryGirl.create(:answer, corresponding_requirements: ['exemplar_1'], question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer2.id)

    requirement.survey_section.survey.reload
    requirement.save

    response_set.reload
    assert_false requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for radio answers - #requirement_met_by_responses? returns false when requirement is met exactly by responses" do
    requirement = FactoryGirl.create(:requirement, reference_identifier: 'standard_1')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :one)
    answer1 = FactoryGirl.create(:answer, corresponding_requirements: ['basic_1'], question: question)
    answer2 = FactoryGirl.create(:answer, corresponding_requirements: ['pilot_1'], question: question)
    answer3 = FactoryGirl.create(:answer, corresponding_requirements: ['standard_1'], question: question)
    answer4 = FactoryGirl.create(:answer, corresponding_requirements: ['exemplar_1'], question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer3.id)

    requirement.survey_section.survey.reload
    requirement.save

    response_set.reload
    assert requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "for radio answers - #requirement_met_by_responses? returns false when requirement is exceeded by responses" do
    requirement = FactoryGirl.create(:requirement, reference_identifier: 'standard_1')
    question = FactoryGirl.create(:question, survey_section: requirement.survey_section, pick: :one)
    answer1 = FactoryGirl.create(:answer, corresponding_requirements: ['basic_1'], question: question)
    answer2 = FactoryGirl.create(:answer, corresponding_requirements: ['pilot_1'], question: question)
    answer3 = FactoryGirl.create(:answer, corresponding_requirements: ['standard_1'], question: question)
    answer4 = FactoryGirl.create(:answer, corresponding_requirements: ['exemplar_1'], question: question)
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    FactoryGirl.create(:response, response_set: response_set, question_id: question.id, answer_id: answer4.id)

    requirement.survey_section.survey.reload
    requirement.save

    response_set.reload
    assert requirement.requirement_met_by_responses?(response_set.responses)
  end

  test "is mandatory for required value of required" do
    question = FactoryGirl.build :question, required: 'required'
    assert question.mandatory?
  end

  [nil, '', 'pilot', 'standard', 'exemplar'].each do |value|
    test "is not mandatory for required value of #{value.inspect}" do
      question = FactoryGirl.build :question, required: value
      assert_false question.mandatory?
    end
  end

  test "#required gets set to string before save if it's nil" do
    question = FactoryGirl.build :question
    question.required = nil
    assert question.required.nil?
    question.save!
    assert_false question.required.nil?
  end

  test "#required should default to being an empty string" do
    question = FactoryGirl.build :question
    assert_equal question.required, ''
  end

  test "statement_text comes from translations" do
    @question = FactoryGirl.create(:question, reference_identifier: 'documentationUrl')
    assert_equal "This data is described at", @question.statement_text
  end

end
