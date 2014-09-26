require 'odibot'

class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods
  include AASM

  # Surveyor field types
  VALUE_FIELDS = [:datetime_value, :integer_value, :float_value, :unit, :text_value, :string_value]

  # Default title for a response set / dataset
  DEFAULT_TITLE = 'Untitled'

  REF_CHANGES = {"ogl_uk" => "OGL-UK-2.0"}

  after_save :update_certificate
  before_save :update_dataset

  attr_accessible :dataset_id
  attr_accessor :documentation_url

  belongs_to :dataset, touch: true
  belongs_to :survey

  # One to one relationship with certificate
  has_one :certificate, dependent: :destroy

  # One to one relationship with kitten data object
  has_one :kitten_data, dependent: :destroy, order: "created_at DESC"
  has_many :autocomplete_override_messages, dependent: :destroy
  has_one :certificate_generator

  # Checks if a value is blank by Surveyor's standards
  def self.is_blank_value?(value)
    value.is_a?(Array) ? value.all?{|values| values.blank? } : value.to_s.blank?
  end

  # Checks if a surveyor hash for a quesiton is considered blank (unanswered)
  # Overloads Surveyor's method to ensure only surveyor values are considered
  def self.has_blank_value?(hash)

    # It's definitely blank if there's no answer id
    return true if is_blank_value?(hash["answer_id"])

    # Otherwise it isn't blank if the question is a radio question
    return false if (q = Question.find_by_id(hash["question_id"])) and q.pick == "one"

    # Otherwise check surveyor values are blank
    hash.slice(*VALUE_FIELDS).any?{|k,v| is_blank_value?(v) }
  end

  # Gets data for status page
  def self.counts
    within_last_month = (Time.now - 1.month)..Time.now
    {
      :all                           => self.count,
      :all_datasets                  => self.select("DISTINCT(dataset_id)").count,
      :all_datasets_this_month       => self.select("DISTINCT(dataset_id)").where(created_at: within_last_month).count,
      :published_datasets            => self.published.select("DISTINCT(dataset_id)").count,
      :published_datasets_this_month => self.published.select("DISTINCT(dataset_id)").where(created_at: within_last_month).count
    }
  end

  def self.clone_response_set(source, attrs = {})
    attrs["survey_id"] ||= source.survey_id
    new_response_set = ResponseSet.create attrs
    new_response_set.kitten_data = source.kitten_data
    new_response_set.copy_answers_from_response_set!(source)
    new_response_set
  end

  # Simple state machine describing response set states
  aasm do
    state :draft, :initial => true

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
    certificate.publish!
  end

  def archive_other_response_sets
    related = dataset.try(:response_sets) || []

    related.each do |response_set|
      if response_set.id != self.id
        response_set.archive! if response_set.published?
      end
    end

  end

  # Store the attained level so that it's queryable
  # Only stored once the certificate has been published
  def store_attained_index
    index = minimum_outstanding_requirement_level-1
    update_attribute(:attained_index, index)
  end

  scope :by_newest, order("response_sets.created_at DESC")
  scope :completed, where("response_sets.completed_at IS NOT NULL")

  def title
    dataset_title_determined_from_responses || DEFAULT_TITLE
  end

  def response(identifier)
    responses.select{|r| r.question.reference_identifier == identifier.to_s }.first
  end

  def documentation_url
    response 'documentationUrl'
  end

  def documentation_url_question
    survey.question 'documentationUrl'
  end

  def documentation_url_explanation
    autocomplete_override_message_for(documentation_url_question.id).message
  end

  def documentation_url_explanation=(val)
    explanation = autocomplete_override_message_for(documentation_url_question.id)
    explanation.message = val
    explanation.save
  end

  # This picks up the jurisdiction (survey title) from the survey, or the migrated survey
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

  # Finds which dependencies are active for this response set as a whole
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

  # Allows response values to be accessed using the suffix '_determined_from_responses'
  def method_missing(method_name, *args, &blk)
    match = method_name.to_s.match(/^(.+)_determined_from_responses$/)
    identifier = match && match[1].to_sym

    # Checks to see if the response identifier is valid
    if Survey::RESPONSE_MAP[identifier]
      # Tries to get an existing instance variable  before loading the value from the database
      var = instance_variable_get("@#{method_name}") || value_for(identifier)
    else
      # Otherwise defaults to Surveyor's method_missing
      super
    end
  end

  # Custom getter which chooses an appropriate data licence
  def data_licence_determined_from_responses
    if @data_licence_determined_from_responses.nil?
      ref = value_for :data_licence, :reference_identifier
      case ref
      when nil
        @data_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "na"
        @data_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "other"
         @data_licence_determined_from_responses = {
          :title => value_for(:other_dataset_licence_name),
          :url   => value_for(:other_dataset_licence_url)
         }
      else
        licence = Odlifier::License.new(REF_CHANGES[ref] || ref.dasherize)
        @data_licence_determined_from_responses = {
          :title => licence.title,
          :url   => licence.url
        }
      end
    end
    @data_licence_determined_from_responses
  end

  # Custom getter which chooses an appropriate content licence
  def content_licence_determined_from_responses
    if @content_licence_determined_from_responses.nil?
      ref = value_for :content_licence, :reference_identifier
      case ref
      when nil
        @content_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "na"
        @content_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "other"
         @content_licence_determined_from_responses = {
          :title => value_for(:other_content_licence_name),
          :url   => value_for(:other_content_licence_url)
         }
      else
        begin
          licence = Odlifier::License.new(REF_CHANGES[ref] || ref.dasherize)
          @content_licence_determined_from_responses = {
            :title => licence.title,
            :url   => licence.url
          }
        rescue ArgumentError
          @content_licence_determined_from_responses = {
            :title => 'Unknown',
            :url   => nil
          }
        end
      end
    else
      @content_licence_determined_from_responses
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

    @triggered_mandatory_questions ||= survey.mandatory_questions.select do |r|
      r.dependency.nil? ?
        true : depends[r.dependency.id]
    end

    # @triggered_mandatory_questions ||= self.survey.mandatory_questions.select { |q| q.triggered?(self) }
  end

  def triggered_requirements
    @triggered_requirements ||= survey.requirements.select do |r|
      r.dependency.nil? ?
        true :
        depends[r.dependency.id]
    end

    # @triggered_requirements ||= survey.requirements.select { |r| r.triggered?(self) }
  end

  def responses_with_url_type
    responses.joins(:answer).where({:answers => {input_type: 'url'}}).readonly(false)
  end

  def explanation_not_given?(question)
    !autocomplete_override_message_for(question).message?
  end

  def all_urls_resolve?
    errors = []
    responses_with_url_type.each do |response|
      unless response.string_value.blank?
        response_code = ODIBot.new(response.string_value).response_code rescue nil
        if response_code != 200 && explanation_not_given?(response.question)
          response.error = true
          response.save
          errors << response
        else
          response.error = false
          response.save
        end
      end
    end
    errors.length == 0
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

    ui_hash = []

    responses.each do |key, value|
      question = survey.question(key)
      response = response(key)

      next if value.nil? || question.nil?

      if question.type == :none || question.type == :repeater
        ui_hash.push(HashWithIndifferentAccess.new(
          question_id: question.id.to_s,
          api_id: response ? response.api_id : Surveyor::Common.generate_api_id,
          answer_id: question.answers.first.id.to_s,
          string_value: value,
          autocompleted: true
        ))
      end

      if question.type == :one
        ui_hash.push(HashWithIndifferentAccess.new(
          question_id: question.id.to_s,
          api_id: response ? response.api_id : Surveyor::Common.generate_api_id,
          answer_id: question.answer(value).id.to_s,
          autocompleted: true
        ))
      end

      if question.type == :any
        value.each do |item|
          ui_hash.push(HashWithIndifferentAccess.new(
            question_id: question.id.to_s,
            api_id: response ? response.api_id : Surveyor::Common.generate_api_id,
            answer_id: question.answer(item).id.to_s,
            autocompleted: true
          ))
        end
      end
    end

    update_from_ui_hash(Hash[ui_hash.map.with_index { |value, i| [i.to_s, value] }])
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

  def autocomplete(url)
    update_responses({documentationUrl: url})
    responses.update_all(autocompleted: false)
    update_attribute('kitten_data', nil)

    code = resolve_url(url)

    if code == 200
      kitten_data = KittenData.create(url: url, response_set: self)
      kitten_data.request_data
      kitten_data.save

      update_attribute('kitten_data', kitten_data)
      update_responses(kitten_data.fields)
    end
  end

  def resolve_url(url)
    if url =~ /^#{URI::regexp}$/
      ODIBot.new(url).response_code rescue nil
    end
  end

  # finds the string value for a given response_identifier
  private
  def value_for reference_identifier, value = :to_s
    responses.joins(:question).where(questions: {reference_identifier: survey.meta_map[reference_identifier]}).first.try(value)
  end

end
