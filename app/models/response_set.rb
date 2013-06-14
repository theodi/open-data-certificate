class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods

  before_save :generate_certificate

  attr_accessible :dataset_id

  belongs_to :dataset
  belongs_to :survey
  has_one :certificate

  DEFAULT_TITLE = 'Untitled'

  scope :by_newest, order("response_sets.created_at DESC")
  scope :completed, where("response_sets.completed_at IS NOT NULL")

  def title
    title_determined_from_responses || ResponseSet::DEFAULT_TITLE
  end


  def title_determined_from_responses
    @title_determined_from_responses ||= responses.joins(:question).where(questions: {reference_identifier: survey.dataset_title}).first.try(:string_value)
  end

  def curator_determined_from_responses
    @curator_determined_from_responses ||= responses.joins(:question).where(questions: {reference_identifier: survey.dataset_curator}).first.try(:string_value)
  end

  def incomplete?
    !complete?
  end

  def incomplete_triggered_mandatory_questions
    responded_to_question_ids = responses.map(&:question_id)
    triggered_mandatory_questions.select { |q| !responded_to_question_ids.include? q.id }    
  end

  def triggered_mandatory_questions
    @triggered_mandatory_questions ||= self.survey.mandatory_questions.select { |q| q.triggered?(self) }
  end

  def triggered_requirements
    @triggered_requirements ||= survey.requirements.select { |r| r.triggered?(self) }
  end

  def all_mandatory_questions_complete?
    mandatory_question_ids = triggered_mandatory_questions.map(&:id)
    responded_to_question_ids = responses.map(&:question_id)
    (mandatory_question_ids - responded_to_question_ids).blank?
  end

  def attained_level
    @attained_level ||= Survey::REQUIREMENT_LEVELS[minimum_outstanding_requirement_level-1]
  end

  def minimum_outstanding_requirement_level
    return 1 unless all_mandatory_questions_complete? # if there are any mandatory questions outstanding, they achieve no level
    @minimum_outstanding_requirement_level ||= (outstanding_requirements.map(&:requirement_level_index) << Survey::REQUIREMENT_LEVELS.size).min
  end

  def completed_requirements
    @completed_requirements ||= triggered_requirements.select { |r| r.requirement_met_by_responses?(self.responses) }
  end

  def outstanding_requirements
    @outstanding_requirements ||= (triggered_requirements - completed_requirements)
  end

  def responses_for_questions(questions)
    responses.includes(:question)
             .where(:question_id => questions)
             .order('questions.display_order ASC')
  end

  def generate_certificate
    if self.complete? && self.certificate.nil?
      create_certificate attained_level: self.attained_level, curator: curator_determined_from_responses, name: title
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


  # run updates through the response_cache_map, so that we can deal 
  # with fields that have been claimed by a different response_set
  #
  # (allows us to cache the question html)
  #
  alias :original_update_from_ui_hash :update_from_ui_hash
  def update_from_ui_hash(ui_hash)

    # the api_ids in the ui_hash
    api_ids = ui_hash.map do |_ord, response_hash|
      response_hash["api_id"]
    end


    # find responses that have been claimed by another response_sets
    Response.where(api_id: api_ids).where('response_set_id != ?', id).each do |response|
      
      # use a mapping to this response_sets api_id instead
      rcm = ResponseCacheMap.find_or_create_by_origin_id_and_response_set_id(response.id, self.id)

      logger.info "cache map replacing api_id - #{response.api_id} with #{rcm.api_id}"

      # replace the one in the ui hash
      ui_hash.each do |_ord, response_hash|
        if response_hash["api_id"] == response.api_id
          response_hash["api_id"] = rcm.api_id
        end
      end
    end
    
    # pass through to the original method
    original_update_from_ui_hash(ui_hash)
  end

  def assign_to_user!(user)
    # This is a bit fragile, as it assumes that there is both no current user and no current dataset, and raises no notification of any issues
    # TODO: revisit and improve its handling of unexpected cases
    self.user = user
    self.dataset = Dataset.create(:user => user)
    save
  end

  def newest_in_dataset?
    # TODO: this method would need to be extended to handle "newest for survey" - for phase 2...
    @newest_in_dataset_q ||= (dataset.try(:newest_response_set) == self)
  end

  def newest_completed_in_dataset?
    # TODO: this method would need to be extended to handle "newest for survey" - for phase 2...
    @newest_in_dataset_q ||= (dataset.try(:newest_completed_response_set) == self)
  end

end
