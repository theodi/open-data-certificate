class Question < ActiveRecord::Base
  include Surveyor::Models::QuestionMethods

  attr_accessible :requirement, :required

  scope :excluding, lambda { |*objects| where(['questions.id NOT IN (?)', (objects.flatten.compact << 0)]) }

  def improvement_level
    #TODO: Create an association to a model for Improvements? Or just leave it as a text key for the translations?
    requirement.to_s.match(/^[a-zA-Z]*/).to_s
  end

  def is_a_requirement?
    display_type == 'label' && !requirement.blank?
  end

  def question_corresponding_to_requirement
    @question_corresponding_to_requirement ||= answer_corresponding_to_requirement.question
  end

  def answer_corresponding_to_requirement
    @answer_corresponding_to_requirement ||= survey_section.survey.sections.map(&:questions).flatten.map(&:answers).flatten.detect{|a|a.requirement == requirement}
  end

  def requirement_met_by_responses?(responses)
    # could use thusly to get all the displayed requirements for a survey and whether they have been met by their corresponding answers:
    #   `response_set.survey.sections.map(&:questions).flatten.select{|e|e.is_a_requirement? && e.triggered?}.map{|e|[e.requirement, e.requirement_met_by_responses?(rs.responses)]}`
    # or if we want to determine the triggered on the associated question rather than the label...
    #   `response_set.survey.sections.map(&:questions).flatten.select{|e|e.is_a_requirement? && e.question_corresponding_to_requirement.triggered?}.map{|e|[e.requirement, e.requirement_met_by_responses?(rs.responses)]}`

    responses_requirements = responses.select{|r| r.question_id == question_corresponding_to_requirement.id}.map{|r|Survey::REQUIREMENT_LEVELS.index(r.answer.improvement_level)} # TODO: Refactor this... it's too long and too stinky
    responses_requirements.max && (responses_requirements.max >= Survey::REQUIREMENT_LEVELS.index(self.improvement_level))
  end

  def default_args
    self.is_mandatory ||= !!required
    super
  end

end
