class Question < ActiveRecord::Base
  include Surveyor::Models::QuestionMethods

  attr_accessible :requirement

  scope :excluding, lambda { |*objects| where(['questions.id NOT IN (?)', (objects.flatten.compact << 0)]) }

  def improvement_level
    #TODO: Create an association to a model for Improvements? Or just leave it as a text key for the translations?
    requirement.to_s.match(/^[a-zA-Z]*/).to_s
  end

  def is_a_requirement?
    display_type == 'label' && !requirement.blank?
  end

  def question_corresponding_to_requirement
    survey_section.survey.sections.map { |s| s.questions.excluding(self).where(["questions.requirement = ?", requirement])}.flatten.first
  end

  def requirement_met_by_responses?(responses)
    # could use thusly to get all the displayed requirements for a survey and whether they have been met by their corresponding answers:
    # response_set.survey.sections.map(&:questions).flatten.select{|e|e.is_a_requirement? && e.triggered?}.map{|e|[e.requirement, e.requirement_met_by_responses?(rs.responses)]}
    responses.map(&:question_id).include?(question_corresponding_to_requirement.id) #TODO: I would fairly comfortable anticipate that the iteration of responses will need to move (for efficiency) to the place where we're calling the 'requirement_met_by_responses?' method
  end

end
