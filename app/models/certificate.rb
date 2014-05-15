class Certificate < ActiveRecord::Base
  belongs_to :response_set

  has_one :survey,  through: :response_set
  has_one :user,    through: :response_set
  has_one :dataset, through: :response_set
  has_many :verifications
  has_many :verifying_users, through: :verifications, source: :user

  attr_accessible :published, :name, :attained_level, :curator

  EXPIRY_NOTICE = 1.month

  class << self
    def search_title(title)
      query = self.where({})
      title.downcase.split(/\s+/).each do |term|
        query = query.where("LOWER(certificates.name) LIKE ?", "%#{term}%")
      end
      query
    end

    def search_publisher(publisher)
      query = self.where({})
      publisher.downcase.split(/\s+/).each do |term|
        query = query.where("LOWER(certificates.curator) LIKE ?", "%#{term}%")
      end
      query
    end

    def search_country(country)
      query = self.where({})
      country.downcase.split(/\s+/).each do |term|
        query = query.joins(response_set: :survey).where("LOWER(surveys.full_title) LIKE ?", "%#{term}%")
      end
      query
    end

    def by_newest
      order("certificates.created_at DESC")
    end

    def group_similar
      joins(:response_set => [:survey]).group('surveys.title, response_sets.dataset_id')
    end

    def badge_file_for_level(level)
      filename = case level
                   when 'basic'
                     'raw_level_badge.png'
                   when 'raw', 'pilot', 'standard', 'exemplar'
                     "#{level}_level_badge.png"
                   else
                     'no_level_badge.png'
                 end

      File.open(File.join(Rails.root, 'app/assets/images/badges', filename))
    end

    def latest
      where(published: true).joins(:response_set).merge(ResponseSet.published).order('certificates.created_at DESC').first
    end

    def counts
      within_last_month = (Time.now - 1.month)..Time.now
      {
        :all                  => self.count,
        :all_this_month       => self.where(created_at: within_last_month).count,
        :published            => self.where(published: true).count,
        :published_this_month => self.where(published: true, created_at: within_last_month).count,
        :levels               => {
          :basic              => self.where(published: true, attained_level: "basic").count,
          :pilot              => self.where(published: true, attained_level: "pilot").count,
          :standard           => self.where(published: true, attained_level: "standard").count,
          :expert             => self.where(published: true, attained_level: "expert").count
        }
      }
    end

    def published_certificates
      self.where(published: true).map do |certificate|
        {
          name: certificate.name,
          publisher: certificate.curator,
          created: certificate.created_at,
          user: certificate.user.email,
          country: certificate.survey.title,
          type: certificate.survey.status,
          level: certificate.attained_level,
          verification_type: certificate.certification_type,
          date_verified: certificate.verifications.count == 0 ? nil : certificate.verifications.last.updated_at
        }
      end
    end

    def set_expired(surveys)
      self.joins(:response_set)
        .where(ResponseSet.arel_table[:survey_id].in(surveys.map(&:id)))
        .where(expires_at: nil)
        .update_all(expires_at: DateTime.now + EXPIRY_NOTICE)
    end
  end

  def expiring?
    expires_at != nil
  end

  def expired?
    expiring? && expires_at < DateTime.now
  end

  def verified_by_user? user
    verifications.exists? user_id: user.id
  end

  def badge_file
    Certificate.badge_file_for_level(attained_level)
  end

  def badge_url
    "/datasets/#{self.response_set.dataset.id}/certificates/#{self.id}/badge.png"
  end

  def embed_url
    "/datasets/#{self.response_set.dataset.id}/certificates/#{self.id}/badge.js"
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
        rs.each do |r|
          if r.statement_text != ''
            responses << r
          end
        end
      end
    end
    responses.group_by { |r| r.question_id }
  end

  def progress
    response_set = self.response_set

    # requirements still to be met
    outstanding = response_set.triggered_requirements.map do |r|
      r.reference_identifier
    end

    # questions that have been answered and their requirements
    entered = response_set.responses.map(&:answer).map do |a|
      a.requirement.try(:scan, /\S+_\d+/) #if a.question.triggered? @response_set
    end

    # the counts of mandatory questions and completions
    mandatory = response_set.incomplete_triggered_mandatory_questions.count
    mandatory_completed = response_set.responses.map(&:question).select(&:is_mandatory).count

    {
      outstanding: outstanding.sort,
      entered: entered.flatten.compact.sort,
      mandatory: mandatory,
      mandatory_completed: mandatory_completed
    }
  end
end
