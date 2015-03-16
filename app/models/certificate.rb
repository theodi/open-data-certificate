class Certificate < ActiveRecord::Base
  include Badges, Counts
  include AASM

  belongs_to :response_set, touch: true

  has_one :survey,  through: :response_set
  has_one :user,    through: :response_set
  has_one :dataset, through: :response_set
  has_one :certificate_generator, through: :response_set
  has_many :verifications
  has_many :verifying_users, through: :verifications, source: :user

  attr_accessible :published, :published_at, :name, :attained_level, :curator, :aasm_state

  EXPIRY_NOTICE = 1.month

  scope :published, where(published: true)
  scope :expired, -> { where("expires_at < ?", Time.current) }
  scope :past_expiry_notice, -> { where(arel_table[:expires_at].lt(Time.current + EXPIRY_NOTICE)) }
  scope :current, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }
  scope :without_expiry, where(expires_at: nil)

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

    def set_expired(surveys)
      for_surveys(surveys).without_expiry.update_all(expires_at: DateTime.now + EXPIRY_NOTICE)
    end

    def for_surveys(surveys)
      joins(:response_set).merge(ResponseSet.where(survey_id: surveys.select('surveys.id')))
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

  def visible?
    published? && dataset.visible?
  end

  def latest?
    dataset.certificate == self
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
    if self.audited?
      :odi_audited
    elsif verifications.count >= 2
      :community
    elsif machine_generated? && !has_newer_responses?(certificate_generator.updated_at)
      :auto
    else
      :self
    end
  end

  def machine_generated?
    certificate_generator.present?
  end

  def has_newer_responses?(datetime)
    newest_response_at = response_set.responses.maximum(:updated_at)
    newest_response_at && newest_response_at > datetime
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

  def url(options={})
    urlgen = Rails.application.routes.url_helpers
    options = options.merge(host: OpenDataCertificate.hostname)
    if latest?
      urlgen.dataset_latest_certificate_url(self.dataset, options)
    else
      urlgen.dataset_certificate_url(self.dataset, self, options)
    end
  end

  def report!(reason, reporter)
    reporter = reporter.presence || 'certificate@theodi.org'
    CertificateMailer.report(self, reason, reporter).deliver
  rescue Net::SMTPServerBusy => e
    Airbrake.notify e, :error_message => "could not send certificate report email from #{reporter}"
  end
  handle_asynchronously :report!

end
