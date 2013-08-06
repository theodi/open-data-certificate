class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods
  include AASM

  after_save :update_certificate

  attr_accessible :dataset_id

  belongs_to :dataset, touch: true
  belongs_to :survey
  has_one :certificate, dependent: :destroy

  # there is already a protected method with this
  # has_many :dependencies, :through => :survey

  aasm do
    state :draft, :initial => true
    state :published, :before_enter => :publish_certificate, :after_enter => :archive_other_response_sets
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


  DEFAULT_TITLE = 'Untitled'

  scope :by_newest, order("response_sets.created_at DESC")
  scope :completed, where("response_sets.completed_at IS NOT NULL")

  def title
    title_determined_from_responses || ResponseSet::DEFAULT_TITLE
  end

  def jurisdiction
    if Survey::MIGRATIONS.has_key? survey.access_code
      target_access_code = Survey::MIGRATIONS[survey.access_code]
      Survey.where(access_code: target_access_code).first.try(:title)
    else
      survey.title
    end
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

  def title_determined_from_responses
    @title_determined_from_responses ||= value_for "dataset_title"
  end

  def curator_determined_from_responses
    @curator_determined_from_responses ||= value_for "dataset_curator"
  end
  
  def documentation_url_determined_from_responses
    @documentation_url_determined_from_responses ||= value_for "dataset_documentation_url"
  end
  
  def curator_url_determined_from_responses
    @curator_url_determined_from_responses ||= value_for "dataset_curator_url"
  end
  
  def data_licence_determined_from_responses
    if @data_licence_determined_from_responses.nil? 
      ref = value_for "data_licence", :reference_identifier
      case ref
      when "na"
        @data_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "other"
         @data_licence_determined_from_responses = {
          :title => value_for("other_dataset_licence_name"),
          :url   => value_for("other_dataset_licence_url")
         }
      else
        licence = ODLifier::License.new(ref)
        @data_licence_determined_from_responses = {
          :title => licence.title,
          :url   => licence.url
        }
      end
    else
      @data_licence_determined_from_responses
    end
  end
  
  def content_licence_determined_from_responses
    if @content_licence_determined_from_responses.nil? 
      ref = value_for "content_licence", :reference_identifier
      case ref
      when "na"
        @content_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "other"
         @content_licence_determined_from_responses = {
          :title => value_for("other_content_licence_name"),
          :url   => value_for("other_content_licence_url") 
         }
      else
        licence = ODLifier::License.new(ref)
        @content_licence_determined_from_responses = {
          :title => licence.title,
          :url   => licence.url
        }
      end
    else
      @content_licence_determined_from_responses
    end
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
  
  def all_urls_resolve?
    errors = []
    responses_with_url_type.each do |response|
      response_code = Rails.cache.fetch(response.string_value) 
      if response_code.nil?
        response_code = HTTParty.get(response.string_value).code rescue nil
      end
      if response_code != 200
        response.error = true
        response.save
        errors << response 
      else
        response.error = false
        response.save
      end
    end
    errors.length > 0 or true
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

  def update_certificate
    create_certificate if certificate.nil?

    certificate.update_from_response_set
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
    self.dataset = user.datasets.create
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

  # finds the string value for a given response_identifier
  private
  def value_for reference_identifier, value = :string_value
    q = responses.joins(:question).where(questions: {reference_identifier: survey.meta_map[reference_identifier.to_sym]}).first.try(value)
  end

end
