require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @question = FactoryGirl.build(:question)
  end

  test "#requirement_level should be the string from 'requirement' attribute" do
    %w(basic pilot standard exemplar).each do |level|
      question = FactoryGirl.build(:question, requirement: "#{level}_#{rand(10)}")
      assert question.requirement_level == level.to_s, "Broke with level: #{level}"
    end
  end

  test "#requirement_level_index should be the index at which the requirement level appears in the REQUIREMENT_LEVELS constant" do
    {basic: 1, pilot: 2, standard: 3, exemplar: 4}.each do |level, index|
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


end
