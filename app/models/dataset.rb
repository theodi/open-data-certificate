class Dataset < ActiveRecord::Base
  belongs_to :user

  delegate :full_name, :email, :to => :user, :prefix => true, :allow_nil => true

  attr_accessible :title

  after_touch :destroy_if_no_responses

  has_many :response_sets, :order => "response_sets.created_at DESC"
  has_many :certificates, :through => :response_sets

  # the currently published response set
  has_one :response_set, conditions: {aasm_state: 'published'}
  has_one :certificate, through: :response_set

  has_one :transfer, conditions: {aasm_state: :notified}

  has_many :embed_stats

  # this subquery is necessary because a group('responses_sets.dataset_id')
  # entirely changes the behaviour of count() so that the pagination fails
  # by generating invalid sql
  scope :with_responses, where(:id => joins(:response_sets).select('datasets.id'))
  scope :with_current_published_certificate, joins(:certificates).merge(Certificate.published.current)
  scope :modified_since, ->(date) { joins(:response_sets).merge(ResponseSet.modified_since(date)) }

  class << self
    def match_to_user_domain(datasetUrl)
      domain = Domainatrix.parse(datasetUrl).domain

      dataset = joins(:user)
                  .where(documentation_url: datasetUrl)
                  .order(User.arel_table[:email].matches(domain))
                  .first

      if dataset.nil?
        dataset = where(:documentation_url => datasetUrl).first
      end
      dataset
    end
  end

  def self.published_count
    with_current_published_certificate.count(:distinct => 'datasets.id')
  end

  def title
    read_attribute(:title) || set_default_title!(response_sets.first.try(:dataset_title_determined_from_responses)) || response_sets.first.try(:title) || ResponseSet::DEFAULT_TITLE
  end

  def documentation_url
    read_attribute(:documentation_url) || set_default_documentation_url!(response_sets.first.try(:dataset_documentation_url_determined_from_responses))
  end

  def curator
    read_attribute(:curator) || set_default_curator!(response_sets.first.try(:dataset_curator_determined_from_responses))
  end

  def set_default_title!(title)
    if title && persisted?
      self.title = title
      save unless readonly?
    end
  end

  def modified_date
    response_set.try(:updated_at) || updated_at
  end

  def set_default_documentation_url!(url)
    if url && persisted?
      self.documentation_url = url
      save unless readonly?
      url
    end
  end

  def set_default_curator!(url)
    if url && persisted?
      self.curator = url
      save unless readonly?
      url
    end
  end

  def newest_response_set
    response_sets.by_newest.limit(1).first
  end

  def newest_completed_response_set
    response_sets.completed.by_newest.limit(1).first
  end

  def destroy_if_no_responses
    destroy if response_sets.empty?
  end

  def register_embed(referer)
    begin
      embed_stats.create(referer: referer)
    rescue ActiveRecord::RecordNotUnique
      nil
    end
  end

  def generation_result
    response_set = newest_response_set

    if response_set.certificate_generator && response_set.certificate_generator.completed?
      errors = []

      response_set.responses_with_url_type.each do |response|
        if response.error
          errors.push("The question '#{response.question.reference_identifier}' must have a valid URL")
        end
      end

      response_set.survey.questions.where(is_mandatory: true).each do |question|
        response = response_set.responses.detect {|r| r.question_id == question.id}

        if !response || response.empty?
          errors.push("The question '#{question.reference_identifier}' is mandatory")
        end
      end

      certificate_url = certificate.url if certificate

      {
        success: true,
        dataset_id: id,
        dataset_url: api_url,
        certificate_url: certificate_url,
        published: response_set.published?,
        owner_email: user_email,
        errors: errors
      }
    else
      {success: "pending", dataset_id: id, dataset_url: api_url}
    end
  end

  def api_url
    Rails.application.routes.url_helpers.dataset_url(self, format: :json, host: OpenDataCertificate.hostname)
  end

  def change_owner!(user)
    update_attribute(:user_id, user.id)
    response_sets.update_all(user_id: user.id)
  end

end
