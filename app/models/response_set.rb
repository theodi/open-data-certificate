class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods

  before_save :generate_certificate

  attr_accessible :dataset_id

  belongs_to :dataset
  belongs_to :survey
  has_one :certificate

  DEFAULT_TITLE = 'Untitled'

  def title
    title_determined_from_responses || ResponseSet::DEFAULT_TITLE
  end

  def title_determined_from_responses
    @title_determined_from_responses ||= responses.joins(:question).where('questions.reference_identifier == ?', 'dataTitle').first.try(:string_value)
  end

  def incomplete?
    !complete?
  end

  def triggered_mandatory_questions
    @triggered_mandatory_questions ||= self.survey.mandatory_questions.select { |q| q.triggered?(self) }
  end

  def triggered_requirements
    @triggered_requirements ||= survey.requirements.select { |r| r.triggered?(self) }
  end

  def attained_level
    @attained_level ||= Survey::REQUIREMENT_LEVELS[minimum_outstanding_requirement_level-1]
  end

  def minimum_outstanding_requirement_level
    @minimum_outstanding_requirement_level ||= (outstanding_requirements.map(&:requirement_level_index) << Survey::REQUIREMENT_LEVELS.size).min
  end

  def completed_requirements
    @completed_requirements ||= triggered_requirements.select { |r| r.requirement_met_by_responses?(self.responses) }
  end

  def outstanding_requirements
    @outstanding_requirements ||= (triggered_requirements - completed_requirements)
  end

  def generate_certificate
    if self.complete? && self.certificate.nil?
      create_certificate :attained_level => self.attained_level
    end
  end

  def copy_answers_from_response_set!(source_response_set)
    ui_hash = HashWithIndifferentAccess.new

    raise "Attempt to over-write existing responses." if responses.any? # TODO: replace with specific exception

    source_response_set.responses.each do |previous_response|
      if question = survey.questions.where(reference_identifier: previous_response.question.reference_identifier).first
        if answer = question.answers.where(reference_identifier: previous_response.answer.reference_identifier).first
          api_id = Surveyor::Common.generate_api_id
          ui_hash[api_id] = { question_id: question.id.to_s,
                              api_id: api_id,
                              answer_id: answer.id.to_s }.merge(previous_response.ui_hash_values)
        end
      end
      update_from_ui_hash(ui_hash)
    end
  end

  def assign_to_user!(user)
    # This is a bit fragile, as it assumes that there is both no current user and no current dataset, and raises no notification of any issues
    # TODO: revisit and improve its handling of unexpected cases
    self.user = user
    self.dataset = Dataset.create(:user => user)
    save
  end

end
