class ResponseSet < ActiveRecord::Base
  include DetermineFromResponses
  include Surveyor::Models::ResponseSetMethods
  include AASM

  after_save :update_certificate
  before_save :update_dataset

  attr_accessible :dataset_id
  attr_accessor :documentation_url

  belongs_to :dataset, touch: true
  belongs_to :survey
  has_one :certificate, dependent: :destroy
  has_one :kitten_data, dependent: :destroy, order: "created_at DESC"
  has_many :autocomplete_override_messages, dependent: :destroy
  has_one :certificate_generator

  VALUE_FIELDS = [:datetime_value, :integer_value, :float_value, :unit, :text_value, :string_value]

  # there is already a protected method with this
  # has_many :dependencies, :through => :survey

  def self.has_blank_value?(hash)
    return true if hash["answer_id"].kind_of?(Array) ? hash["answer_id"].all?{|id| id.blank?} : hash["answer_id"].blank?
    return false if (q = Question.find_by_id(hash["question_id"])) and q.pick == "one"
    hash.slice(*VALUE_FIELDS).any?{|k,v| v.is_a?(Array) ? v.all?{|x| x.to_s.blank?} : v.to_s.blank?}
  end

  aasm do
    state :draft,
              :initial => true

    state :published,
              :before_enter => :publish_certificate,
              :after_enter => [:archive_other_response_sets, :store_attained_index]

    state :archived

    event :publish do
      transitions from: :draft, to: :published, guard: :all_mandatory_questions_complete?
    end

    event :archive do
      transitions from: :published, to: :archived
    end
  end

  def publish_certificate
    certificate.update_attribute :published, true
  end

  def archive_other_response_sets
    related = dataset.try(:response_sets) || []

    related.each do |response_set|
      if response_set.id != self.id
        response_set.archive! if response_set.published?
      end
    end

  end

  # store the attained level so that it's queryable (only stored
  # once the certificate has been published)
  def store_attained_index
    index = minimum_outstanding_requirement_level-1
    update_attribute(:attained_index, index)
  end

  DEFAULT_TITLE = 'Untitled'

  scope :by_newest, order("response_sets.created_at DESC")
  scope :completed, where("response_sets.completed_at IS NOT NULL")

  def title
    dataset_title_determined_from_responses || ResponseSet::DEFAULT_TITLE
  end

  def response(identifier)
    responses.select{|r| r.question.reference_identifier == identifier.to_s }.first
  end

  def documentation_url
    response 'documentationUrl'
  end

  def jurisdiction
    if Survey::MIGRATIONS.has_key? survey.access_code
      target_access_code = Survey::MIGRATIONS[survey.access_code]
      Survey.where(access_code: target_access_code).first.try(:title)
    else
      survey.title
    end
  end

  def translation
    survey.translations.where(locale: locale || I18n.locale).first
  end

  def locale_name
    translation.try(:locale_name) || survey.default_locale_name || locale
  end

  def modifications_allowed?
    draft?
  end

  # find which dependencies are active for this response set as a whole
  def depends
    return @depends if @depends

    deps = survey.dependencies.includes({:dependency_conditions => {:question => :answers}})

    resps = self.responses.includes(:answer)

    # gather if the dependencies are met in a hash
    @depends = deps.all.reduce({}) do |mem, v|
      mem[v.id] = v.is_met? self, resps
      mem
    end
  end

  def licences
    {
      data:     begin data_licence_determined_from_responses    rescue nil end,
      content:  begin content_licence_determined_from_responses rescue nil end
    }
  end

  def incomplete?
    !complete?
  end

  def incomplete_triggered_mandatory_questions
    responded_to_question_ids = responses.map(&:question_id)
    triggered_mandatory_questions.select { |q| !responded_to_question_ids.include? q.id }
  end

  def triggered_mandatory_questions

    @triggered_mandatory_questions ||= select_triggered(survey.mandatory_questions)
    # @triggered_mandatory_questions ||= self.survey.mandatory_questions.select { |q| q.triggered?(self) }
  end

  def triggered_requirements
    @triggered_requirements ||= select_triggered(survey.requirements)
    # @triggered_requirements ||= survey.requirements.select { |r| r.triggered?(self) }
  end

  def responses_with_url_type
    responses.joins(:answer).where({:answers => {input_type: 'url'}}).readonly(false)
  end

  def all_urls_resolve?
    @url_errors = []
    responses_with_url_type.each do |response|
      resolve_url(response)
    end
    @url_errors.length == 0
  end

  def resolve_url(response)
    return nil if response.string_value.blank?

    response_code = Rails.cache.fetch(response.string_value) rescue nil
    if response_code.nil?
      response_code = HTTParty.get(response.string_value).code rescue nil
    end
    response.error = (response_code != 200)
    response.save
    @url_errors << response if response.error === true
  end

  def all_mandatory_questions_complete?
    mandatory_question_ids = triggered_mandatory_questions.map(&:id)
    responded_to_question_ids = responses.select(&:filled?).map(&:question_id)
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
    @outstanding_requirements ||= triggered_requirements.select { |r| !r.requirement_met_by_responses?(self.responses) }
  end

  def responses_for_questions(questions)
    responses.includes(:question)
             .where(:question_id => questions)
             .order('questions.display_order ASC')
  end

  def update_certificate
    create_certificate if certificate.nil?

    certificate.update_from_response_set
  end

  def update_dataset
    create_dataset if dataset.nil?
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
                              answer_id: answer.id.to_s,
                              response_group: previous_response.response_group }.merge(previous_response.ui_hash_values)
        end
      end
    end
    update_from_ui_hash(ui_hash)
  end

  # run updates through the response_cache_map, so that we can deal
  # with fields that have been claimed by a different response_set
  #
  # (allows us to cache the question html)
  #
  alias :original_update_from_ui_hash :update_from_ui_hash
  def update_from_ui_hash(ui_hash)

    ui_hash.each do |_ord, response_hash|
      autocomplete_message = autocomplete_override_message_for(response_hash[:question_id])
      autocomplete_message.update_attributes(response_hash.delete('autocomplete_override_message'))
    end

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

  # Updates responses without using a surveyor form
  def update_responses(responses)

    @ui_hash = []

    responses.each do |key, value|
      question = survey.question(key)
      response = response(key)

      next if value.nil? || question.nil?

      update_response(question, response, [value])
    end

    update_from_ui_hash(Hash[@ui_hash.map.with_index { |value, i| [i.to_s, value] }])
  end

  def update_response(question, response, value)
    value.flatten.each do |value|
      if question.type == :none || question.type == :repeater
        string_value = value
      end

      @ui_hash.push(HashWithIndifferentAccess.new(
        question_id: question.id.to_s,
        api_id: response ? response.api_id : Surveyor::Common.generate_api_id,
        answer_id: string_value.nil? ? question.answer(value).id.to_s : question.answers.first.id.to_s,
        string_value: string_value,
        autocompleted: true
      ).delete_if { |k,v| v.nil? })
    end
  end

  def assign_to_user!(user)
    self.user = user
    self.dataset = user.datasets.create if !self.dataset
    self.dataset.update_attribute(:user, user)
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

  def autocomplete_override_message_for(question)
    autocomplete_override_messages.where(question_id: question).first_or_create
  end

  # finds the string value for a given response_identifier
  private
  def value_for reference_identifier, value = :to_s
    responses.joins(:question).where(questions: {reference_identifier: survey.meta_map[reference_identifier]}).first.try(value)
  end

  def select_triggered(selector)
    selector.select do |r|
      r.dependency.nil? ?
        true :
        depends[r.dependency.id]
    end
  end

end
