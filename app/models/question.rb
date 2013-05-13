class Question < ActiveRecord::Base
  include Surveyor::Models::QuestionMethods

  attr_accessible :requirement, :required, :help_text_more_url

  scope :excluding, lambda { |*objects| where(['questions.id NOT IN (?)', (objects.flatten.compact << 0)]) }

  after_save :update_mandatory

  def requirement_level
    # Definition: The level to which the current question is assigned. This is used to determine the level for achieved
    #             and outstanding requirements, and for the display customisation of questions.
    #TODO: Create an association to a model for Improvements? Or just leave it as a text key for the translations?
    @requirement_level ||= requirement.to_s.match(/^[a-zA-Z]*/).to_s
  end

  def requirement_level_index
    @requirement_level_index ||= Survey::REQUIREMENT_LEVELS.index(requirement_level)
  end

  def is_a_requirement?
    # Definition: A 'Requirement' is an bar that needs to be passed to contribute to attaining a certain level in the questionnaire.
    #             This is not the same as being "required" - which is about whether a question is mandatory to be completed.
    #             For the moment, requirements are stored in the DB as labels with a 'requirement' attribute set.
    @is_a_requirement ||= display_type == 'label' && !requirement.blank?
  end

  def question_corresponding_to_requirement
    @question_corresponding_to_requirement ||= survey_section.survey.questions.detect{|q|q.requirement == requirement}
  end

  def answer_corresponding_to_requirement
    @answer_corresponding_to_requirement ||= survey_section.survey.questions.map(&:answers).flatten.detect{|a|a.requirement == requirement}
  end

  def requirement_met_by_responses?(responses)
    # could use thusly to get all the displayed requirements for a survey and whether they have been met by their corresponding answers:
    #   `response_set.survey.questions.flatten.select{|e|e.is_a_requirement? && e.triggered?(response_set)}.map{|e|[e.requirement, e.requirement_met_by_responses?(rs.responses)]}`
    @requirement_met_by_responses ||= calculate_if_requirement_met_by_responses(responses)
  end

  private
  def calculate_if_requirement_met_by_responses(responses)
    question = answer_corresponding_to_requirement.try(:question) || question_corresponding_to_requirement

    responses_requirements = responses.select{|r| r.question_id == question.id}.map(&:requirement_level_index) # TODO: Refactor this... it's too long and too stinky
    !!(responses_requirements.max && (responses_requirements.max >= requirement_level_index))
  end

  private
  def update_mandatory
    #TODO: swap to using an observer instead?
    self.is_mandatory ||= !!required
    Question.update(id, :is_mandatory=>is_mandatory) if is_mandatory_changed?
  end

end
