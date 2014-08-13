class Question < ActiveRecord::Base
  include Surveyor::Models::QuestionMethods

  attr_accessible :requirement, :required, :help_text_more_url, :text_as_statement, :display_on_certificate, :discussion_topic
  attr_accessor :minimum_level

  scope :excluding, lambda { |*objects| where(['questions.id NOT IN (?)', (objects.flatten.compact << 0)]) }

  before_save :cache_question_or_answer_corresponding_to_requirement
  before_save :set_default_value_for_required
  after_save :update_mandatory

  belongs_to :question_corresponding_to_requirement, :class_name => "Question"
  belongs_to :answer_corresponding_to_requirement, :class_name => "Answer"

  LEVELS = {
    'basic' => 1,
    'pilot' => 2,
    'standard' => 3,
    'exemplar' => 4
  }

  class << self
    def compute_levels(questions)
      questions.map.with_index do |question, i|
        requirements = []
        i += 1
        while questions[i] && questions[i].is_a_requirement? do
          requirements.push(questions[i])
          i += 1
        end
        question.minimum_level = get_minimum_level(question, requirements)
      end
    end

    def get_minimum_level(question, requirements)
      level = requirements.map(&:requirement_level).map{|l| LEVELS[l] }.min
      LEVELS.key(level) || (question.required? ? 'basic' : nil)
    end
  end

  # either provided text_as_statement, or fall back to text
  def statement_text
    text_as_statement || text
  end

  def requirement_level
    # Definition: The level to which the current question is assigned. This is used to determine the level for achieved
    #             and outstanding requirements, and for the display customisation of questions.
    #TODO: Create an association to a model for Improvements? Or just leave it as a text key for the translations?
    @requirement_level ||= requirement.to_s.match(/^[a-zA-Z]*/).to_s
  end

  def requirement_level_index
    @requirement_level_index ||= Survey::REQUIREMENT_LEVELS.index(requirement_level) || 0
  end

  def is_a_requirement?
    # Definition: A 'Requirement' is a bar that needs to be passed to contribute to attaining a certain level in the questionnaire.
    #             This is not the same as being "required" - which is about whether a question is mandatory to be completed.
    #             For the moment, requirements are stored in the DB as labels with a 'requirement' attribute set.
    @is_a_requirement ||= display_type == 'label' && !requirement.blank?
  end

  def requirement_met_by_responses?(responses)
    # could use thusly to get all the displayed requirements for a survey and whether they have been met by their corresponding answers:
    #   `response_set.survey.questions.flatten.select{|e|e.is_a_requirement? && e.triggered?(response_set)}.map{|e|[e.requirement, e.requirement_met_by_responses?(rs.responses)]}`
    @requirement_met_by_responses ||= calculate_if_requirement_met_by_responses(responses)
  end

  def dependent?
    @dependent_q ||= self.dependency(includes: :dependency_conditions) != nil
  end

  def metadata_field?
    @metadata_field ||= survey_section.survey.metadata_fields.include?(reference_identifier)
  end

  def triggered?(response_set)
    dep_map = response_set.depends
    @triggered_q ||= dependency.nil? || dep_map[dependency.id]
  end

  def required?
    is_mandatory || answers.detect{|a| a.requirement && a.requirement.match(/pilot_\d+/) }
  end

  def type
    @type ||= question_group && question_group.display_type == 'repeater' ? :repeater : pick.to_sym
  end

  def answer(identifier)
    answers.select{|a| a.reference_identifier == identifier }.first
  end

  def translation(locale)
    {:text => self.text, :help_text => self.help_text}.with_indifferent_access
  end

  def calculate_question_corresponding_to_requirement
    get_questions.detect { |q| corresponds_to_requirement?(q, requirement) }
  end

  def calculate_answer_corresponding_to_requirement
    get_answers.detect { |a| corresponds_to_requirement?(a, requirement) }
  end

  def get_answers
    survey_section.survey.only_questions.map(&:answers).flatten
  end

  def get_questions
    survey_section.survey.only_questions
  end

  def corresponds_to_requirement?(subject, requirement)
    subject.requirement && requirement && subject.requirement.include?(requirement)
  end

  private

  def calculate_if_requirement_met_by_responses(responses)
    # NOTE: At the moment, there is an expectation that each requirement is associated to only one question or answer in
    #       a survey
    #       If a requirement is tied to more that one question or answer, then the calculation of whether it's met needs
    #       to be more comprehensive - it would have to ensure that *every* occurrence of the requirement has been met to
    #       definitively say the requirement has been met.
    #       Validation in the Survey model is used to prevent a requirement getting linked to more than one question or answer
    question = answer_corresponding_to_requirement.try(:question) || question_corresponding_to_requirement

    return false unless question # if for some reason a matching question is not found

    !!(response_level_index(question, responses) >= requirement_level_index)
  end

  def response_level_index(question, responses)
    if question.pick == 'one'
      max_level_for_responses(question.id, responses)
    else
      requirement_level_for_responses(question.id, responses)
    end
  end

  def max_level_for_responses(question_id, responses)
    responses.where(:question_id => question_id).map(&:requirement_level_index).max.to_i
  end

  def requirement_level_for_responses(question_id, responses)
    responses.joins(:answer).where(["responses.question_id = ? AND answers.requirement = ?", question_id, requirement])
                            .first
                            .try(:requirement_level_index)
                            .to_i
  end

  def update_mandatory
    #TODO: swap to using an observer instead?
    self.is_mandatory ||= required.present?
    Question.update(id, :is_mandatory => is_mandatory) if is_mandatory_changed?
  end

  def set_default_value_for_required
    self.required ||= '' # don't let requirement be nil, as we're querying the DB for it in the Survey, so it needs to be an empty string if nothing
  end

  def cache_question_or_answer_corresponding_to_requirement
    if survey_section && is_a_requirement?
      self.question_corresponding_to_requirement ||= calculate_question_corresponding_to_requirement

      unless self.question_corresponding_to_requirement
        self.answer_corresponding_to_requirement ||= calculate_answer_corresponding_to_requirement
      end
    end
  end

end
