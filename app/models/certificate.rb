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

    def within_last_month
      (Time.now - 1.month)..Time.now
    end

    def counts
      Hash[[:all, :all_this_month, :published, :published_this_month, :levels].map do |count|
        [count, Certificate.send("count_#{count}")]
      end]
    end

    def count_levels
      Hash[[:basic, :pilot, :standard, :expert].map do |level|
        [level, Certificate.where(published: true, attained_level: level).count]
      end]
    end

    def count_all
      self.count
    end

    def count_all_this_month
      self.where(created_at: within_last_month).count
    end

    def count_published
      self.where(published: true).count
    end

    def count_published_this_month
      self.where(published: true, created_at: within_last_month).count
    end

    def published
      self.where(published: true)
    end

    def set_expired(surveys)
      expired.update_all(expires_at: DateTime.now + EXPIRY_NOTICE)
    end

    def expired
      self.joins(:response_set)
        .where(ResponseSet.arel_table[:survey_id].in(surveys.map(&:id)))
        .where(expires_at: nil)
    end
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

  def progress_by_level
    result = {}
    progress ||= self.progress
    pending = progress[:mandatory]
    complete = progress[:mandatory_completed]

    [
     'basic',
     'pilot',
     'standard',
     'exemplar'
    ].each do |level|
      pending += progress[:outstanding].select { |p| p =~ /#{level}_/ }.count
      complete += progress[:entered].select { |p| p =~ /#{level}_/ }.count

      result[level.to_sym] = ((complete.to_f / (pending.to_f + complete.to_f)) * 100).round(1)
    end
    result
  end

  def progress_by_section
    results = {
      outstanding: {},
      entered: {}
    }
    progress ||= self.progress

    results.map do |k,v|
      progress[k].each do |p|
        q = Question.where(reference_identifier: p).first
        v[q.survey_section_id] ||= []
        v[q.survey_section_id] << p
      end
    end

  end

end
