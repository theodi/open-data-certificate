require 'odibot'

class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods
  include AASM
  include Ownership

  # Surveyor field types
  VALUE_FIELDS = [:datetime_value, :integer_value, :float_value, :unit, :text_value, :string_value]

  # Default title for a response set / dataset
  DEFAULT_TITLE = 'Untitled'

  REF_CHANGES = {
                  "ogl_uk" => "OGL-UK-2.0",
                  "cc_zero" => "CC0-1.0",
                  "odc_odbl" => "ODbL-1.0",
                  "cc_by" => "CC-BY-4.0",
                  "cc_by_sa" => "CC-BY-SA-4.0",
                  "odc_by" => "ODC-BY-1.0",
                  "odc_pddl" => "ODC-PDDL-1.0"
                }

  after_save :update_certificate
  before_save :update_dataset, :add_missing_responses

  attr_accessible :dataset_id
  attr_accessor :documentation_url

  belongs_to :dataset, touch: true
  belongs_to :survey

  has_many :questions, through: :responses
  has_many :answers, through: :responses

  # One to one relationship with certificate
  has_one :certificate, dependent: :destroy

  # One to one relationship with kitten data object
  has_one :kitten_data, dependent: :destroy, order: "created_at DESC"
  has_one :certificate_generator

  scope :published, where(:aasm_state => 'published')

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
    attrs = {"survey_id" => source.survey_id}.merge(attrs)
    new_response_set = ResponseSet.create attrs
    new_response_set.kitten_data = source.kitten_data.dup if source.kitten_data.present?
    new_response_set.copy_answers_from_response_set!(source)
    new_response_set
  end

  def self.latest
    order(arel_table[:created_at].desc).first
  end

  # Simple state machine describing response set states
  aasm do
    state :draft, :initial => true

    state :published,
      :before_enter => :publish_certificate,
      :after_enter => [:archive_other_response_sets, :store_attained_index]

    state :archived

    state :superceded

    event :publish do
      transitions from: :draft, to: :published, guard: :all_mandatory_questions_complete?
    end

    event :archive do
      transitions from: :published, to: :archived
    end

    event :supercede do
      transitions from: [:draft, :published], to: :superceded
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
  scope :modified_since, ->(date) { where(arel_table[:updated_at].gteq(date)) }

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
    response_for(documentation_url_question.id).explanation
  end

  def documentation_url_explanation=(val)
    response = response_for(documentation_url_question.id)
    response.explanation = val.presence
    response.save
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
    @data_licence_determined_from_responses ||= licence_from_ref(:data_licence)
  end

  # Custom getter which chooses an appropriate content licence
  def content_licence_determined_from_responses
    @content_licence_determined_from_responses ||= licence_from_ref(:content_licence)
  end

  def licence_from_ref(licence_type)
    ref = value_for(licence_type, :reference_identifier)
    case ref
    when nil, "na"
      {
        :title => "Not Applicable",
        :url => nil
      }
    when "other"
      case licence_type
      when :data_licence
        {
          :title => value_for(:other_dataset_licence_name),
          :url   => value_for(:other_dataset_licence_url)
        }
      when :content_licence
        {
          :title => value_for(:other_content_licence_name),
          :url   => value_for(:other_content_licence_url)
        }
      end
    else
      {
        title: value_for(licence_type),
        url: nil
      }
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
    responded_to_question_ids = responses.filled.pluck('question_id')
    triggered_mandatory_questions.reject { |q| responded_to_question_ids.include? q.id }
  end

  def triggered_mandatory_questions

    @triggered_mandatory_questions ||= survey.mandatory_questions.select do |r|
      r.dependency.nil? ?
        true : depends[r.dependency.id]
    end
  end

  def triggered_requirements
    @triggered_requirements ||= survey.requirements.select do |r|
      r.dependency.nil? ?
        true :
        depends[r.dependency.id]
    end
  end

  def outstanding_reference_identifiers
    triggered_requirements.map(&:reference_identifier)
  end

  def entered_reference_identifiers
    answers.includes(:question).map(&:requirement).map do |ref|
      ref.try(:scan, /\S+_\d+/)
    end.flatten.compact
  end

  def levels_count(reference_identifiers)
    # split level name off before _, count by occurance
    Hash[reference_identifiers.group_by { |r| r.split('_')[0] }.map { |k, v| [k, v.size] }]
  end

  def progress
    pending = incomplete_triggered_mandatory_questions.count
    complete = questions.mandatory.count
    outstanding = levels_count(outstanding_reference_identifiers)
    entered = levels_count(entered_reference_identifiers)

    result = {
      attained: attained_level
    }
    %w[basic pilot standard exemplar].each do |level|
      pending += outstanding[level] || 0
      complete += entered[level] || 0
      total = pending+complete
      if total > 0
        result[level] = (100.0*complete/total).to_i
      else
        result[level] = 0
      end
    end
    result
  end

  def responses_with_url_type
    responses.joins(:answer).merge(Answer.urls).readonly(false)
  end

  def all_urls_resolve?
    responses_with_url_type.all?(&:url_valid_or_explained?)
  end

  def uncompleted_mandatory_questions_count
    mandatory_question_ids = triggered_mandatory_questions.map(&:id)
    responded_to_question_ids = responses.select(&:filled?).map(&:question_id)
    (mandatory_question_ids - responded_to_question_ids).count
  end

  def all_mandatory_questions_complete?
    uncompleted_mandatory_questions_count == 0
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
                              answer_id: answer.id.to_s }.merge(previous_response.ui_hash_values)
        end
      end
    end
    original_update_from_ui_hash(ui_hash)
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

  # Updates responses without using a surveyor form
  def update_responses(responses)

    ui_hash = []

    responses.each do |key, value|
      question = survey.question(key)
      response = response(key)

      next if value.nil? || question.nil?

      if question.type == :none || question.type == :repeater
        answer = question.answers.first
        ui_hash.push(HashWithIndifferentAccess.new(
          question_id: question.id.to_s,
          api_id: response ? response.api_id : Surveyor::Common.generate_api_id,
          answer_id: answer.id.to_s,
          answer.value_key => value.to_s,
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

  def response_errors
    errors = Hash.new { |h, k| h[k] = [] }
    incomplete_triggered_mandatory_questions.each do |question|
      response = responses.where(question_id: question.id).first

      if !response || response.empty?
        errors[question.reference_identifier] << 'mandatory'
      end
    end
    responses_with_url_type.each do |response|
      unless response.url_valid_or_explained?
        errors[response.question.reference_identifier] << 'invalid-url'
      end
    end
    errors
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

  def response_for(question_id)
    responses.where(question_id: question_id).first || responses.where(question_id: question_id).build
  end

  def autocomplete(url)
    update_responses({documentationUrl: url})
    responses.update_all(autocompleted: false)
    update_attribute('kitten_data', nil)

    code = resolve_url(url)

    if code == 200
      create_kitten_data(url: url)
      update_responses(kitten_data.fields)
    end
  end

  def has_kitten_data?
    kitten_data && kitten_data.has_data?
  end

  def description
    kitten_data.get(:description) if has_kitten_data?
  end

  def resolve_url(url)
    if url =~ /^#{URI::regexp}$/
      ODIBot.new(url).response_code rescue nil
    end
  end

  # finds the string value for a given response_identifier
  private
  def value_for(reference_identifier, value = :to_s)
    relation = responses.joins(:question).eager_load(:answer, :question)
    relation.where(questions: {reference_identifier: survey.meta_map[reference_identifier]}).first.try(value)
  end

  def add_missing_responses
    self.missing_responses = incomplete_triggered_mandatory_questions.map { |q| q.text }.join(",")
  end

end
