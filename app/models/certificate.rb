class Certificate < ActiveRecord::Base
  include Badges, Counts
  include AASM

  belongs_to :response_set

  has_one :survey,  through: :response_set
  has_one :user,    through: :response_set
  has_one :dataset, through: :response_set
  has_many :verifications
  has_many :verifying_users, through: :verifications, source: :user

  attr_accessible :published, :published_at, :name, :attained_level, :curator, :aasm_state

  EXPIRY_NOTICE = 1.month

  class << self
    def type_search(type, term, query)
      case type
      when "title"
        query.where("LOWER(certificates.name) LIKE ?", "%#{term}%")
      when "publisher"
        query.where("LOWER(certificates.curator) LIKE ?", "%#{term}%")
      when "country"
        query.joins(response_set: :survey).where("LOWER(surveys.full_title) LIKE ?", "%#{term}%")
      end
    end

    def method_missing(name, *args, &block)
      match = name.to_s.match(/^search_(.*)$/)
      if match
        query = self.where({})
        args.first.split(/\s+/).each do |term|
          query = self.type_search(match[1], term, query)
        end
        query
      end
    end

    def by_newest
      order("certificates.created_at DESC")
    end

    def group_similar
      joins(:response_set => [:survey]).group('surveys.title, response_sets.dataset_id')
    end

    def latest
      where(published: true).joins(:response_set).merge(ResponseSet.published).order('certificates.created_at DESC').first
    end

    def published
      self.where(published: true)
    end

    def set_expired(surveys)
      expired(surveys).update_all(expires_at: DateTime.now + EXPIRY_NOTICE)
    end

    def expired(surveys)
      self.joins(:response_set)
        .where(ResponseSet.arel_table[:survey_id].in(surveys.map(&:id)), expires_at: nil)
    end
  end

  aasm do
    state :draft,
          initial: true

    state :published,
          before_enter: :publish_certificate

    event :publish do
      transitions from: :draft, to: :published
    end

    event :draft do
      transitions from: :published, to: :draft
    end
  end

  def publish_certificate
    update_attributes(published: true, published_at: DateTime.now)
  end

  def status
    published? ? "published" : "draft"
  end

  def expiring?
    expires_at != nil
  end

  def expired?
    expiring? && expires_at < DateTime.now
  end

  def days_to_expiry
    if expiring?
      (expires_at.to_date - Date.today).to_i
    else
      nil
    end
  end

  def expiring_state
    return nil if ["draft", "archived"].include?(response_set.aasm_state)
    if expired?
      "expired"
    elsif expiring?
      "expiring"
    else
      nil
    end
  end

  def aasm_state
    self[:aasm_state] || "draft"
  end

  def verified_by_user? user
    verifications.exists? user_id: user.id
  end

  def attained_level_title
    "#{self.attained_level.titleize} Level Certificate"
  end

  def certification_type
    return :odi_audited if self.audited
    verifications.count >= 2 ? :community : :self
  end

  def update_from_response_set

    unless response_set_id.nil?

      # because of the caching of attained level etc, we have to load
      # a new instance of the response_set to calculate these freshly
      #
      # A fix to this is to calculate the attained_level
      # more effectively (related - #362)
      r2 = ResponseSet.find response_set_id
      update_attributes({
        attained_level: r2.attained_level,
        curator:  r2.dataset_curator_determined_from_responses,
        name:  r2.title
      })

    end
  end

  def get_responses
    responses = []

    self.response_set.survey.sections.each do |section|
      qs = section.questions_for_certificate self.response_set
      rs = self.response_set.responses_for_questions qs
      if rs.any?
        rs.each { |r| responses << r if r.statement_text != '' }
      end
    end
    responses.group_by { |r| r.question_id }
  end

  def progress
    {
      outstanding: outstanding.sort,
      entered: entered.flatten.compact.sort,
      mandatory: mandatory,
      mandatory_completed: mandatory_completed
    }
  end

  def outstanding
    response_set.triggered_requirements.map do |r|
      r.reference_identifier
    end
  end

  def entered
    response_set.responses.map(&:answer).map do |a|
      a.requirement.try(:scan, /\S+_\d+/) #if a.question.triggered? @response_set
    end
  end

  def mandatory
    response_set.incomplete_triggered_mandatory_questions.count
  end

  def mandatory_completed
    completed_questions.select(&:is_mandatory).count
  end

  def completed_questions
    response_set.responses.map(&:question)
  end

end
