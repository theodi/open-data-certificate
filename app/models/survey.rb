class Survey < ActiveRecord::Base
  include Surveyor::Models::SurveyMethods

  serialize :meta_map, Hash

  STATUSES = %w(alpha beta final)

  REQUIREMENT_LEVELS = %w(none basic pilot standard exemplar)

  # Hash of access survey codes which have changed
  MIGRATIONS = {'open-data-certificate-questionnaire' => 'gb'}

  # Temporary - when we have the jurisdiction choice at the start, this won't be needed
  DEFAULT_ACCESS_CODE = 'gb'

  RESPONSE_MAP = {
    :dataset_title              => 'dataTitle',
    :dataset_curator            => 'publisher',
    :dataset_documentation_url  => 'documentationUrl',
    :dataset_curator_url        => 'publisherUrl',
    :data_licence               => 'dataLicence',
    :content_licence            => 'contentLicence',
    :other_dataset_licence_name => 'otherDataLicenceName',
    :other_dataset_licence_url  => 'otherDataLicenceURL',
    :other_content_licence_name => 'otherContentLicenceName',
    :other_content_licence_url  => 'otherContentLicenceURL',
    :release_type               => 'releaseType',
  }

  validate :ensure_requirements_are_linked_to_only_one_question_or_answer
  attr_accessible :full_title, :meta_map, :status, :dataset_title, :dataset_curator

  has_many :response_sets, :inverse_of => :survey
  has_many :questions, :through => :sections, :include => {:dependency => :dependency_conditions}, :inverse_of => :survey
  has_many :dependencies, :through => :questions
  has_many :answers, through: :questions

  def self.by_jurisdiction(access_code)
    where(access_code: access_code)
  end

  def self.country_count
    where("status != 'alpha'").group('access_code').select('id').all.count
  end

  def self.available_to_complete
    order('coalesce(full_title, title), survey_version DESC').group(:access_code)
  end

  def self.newest_survey_for_access_code(access_code)
    by_jurisdiction(access_code).order("surveys.survey_version DESC").first
  end

  def self.migrate_access_code(access_code)
    Survey::MIGRATIONS[access_code] || access_code
  end

  def previous_access_codes
    Survey::MIGRATIONS.select{|k, v| v == access_code}.keys
  end

  def previous_surveys
    t = Survey.arel_table
    Survey.where(
      t[:access_code].in([previous_access_codes]).or(
        t[:survey_version].lt(survey_version).and(t[:access_code].eq(access_code))
      )
    ).order("created_at DESC")
  end

  def previous_survey
    @previous_survey ||= previous_surveys.first
  end

  def status_incremented?
    previous_survey ? STATUSES.index(status) > STATUSES.index(previous_survey.status) : false
  end

  def set_expired_certificates
    if status_incremented?
      Certificate.set_expired(previous_surveys)
    end
  end

  def complete_title
    full_title || title
  end

  def metadata_fields
    Set.new ['copyrightStatementMetadata', 'documentationMetadata', 'distributionMetadata']
  end

  def meta_map
    RESPONSE_MAP.merge(read_attribute(:meta_map).symbolize_keys)
  end

  def question_for_attribute(ref)
    meta_map[ref]
  end

  def superseded?
    !(self.id == Survey.newest_survey_for_access_code(access_code).try(:id))
  end

  def requirements
    questions.where(is_requirement: true)
  end

  def only_questions
    questions.where(is_requirement: false)
  end

  def mandatory_questions
    questions.mandatory
  end

  def valid?(context = nil)
    super(context)
    unless errors.empty?

      sections.each do |section|
        unless section.errors.empty?
          puts "section '#{section.title}' errors: #{section.errors.full_messages}"

          questions.each do |question|
            unless question.errors.empty?
              puts "question '#{question.text}' errors: #{question.errors.full_messages}"

              question.answers.each do |answer|
                puts "answer '#{answer.text}' errors: #{answer.errors.full_messages}" unless answer.errors.empty?
              end

            end
          end

        end
      end

    end

    return errors.empty?
  end

  def language
    translations.first.locale
  end

  def intro
    translation(I18n.locale)[:description] || ""
  end

  ### override surveyor methods

  def translations
    puts caller
    raise NotImplementedError, 'We are not using the translations built into Surveyor'
  end

  def translation(locale_symbol)
    @translation ||= begin
      I18n.translate('surveyor').merge({"title" => title}).with_indifferent_access
    end
  end

  def question(identifier)
    questions.for_id(identifier).first
  end

  def documentation_url
    question 'documentationUrl'
  end

  ### /override surveyor methods

  def self.options_for_select
    available_to_complete.select([:access_code, :full_title]).map { |survey| [survey.full_title, survey.access_code] }
  end

  private

  def ensure_requirements_are_linked_to_only_one_question_or_answer
    # can't rely on the methods for these collections, as for new surveys nothing will be persisted to DB yet
    questions = sections.map(&:questions).flatten.compact
    requirements, only_questions = questions.partition(&:is_requirement?)
    answers = only_questions.map(&:answers).flatten.compact

    requirements.each do |requirement|
      amount = only_questions.select { |q| q != requirement && q.corresponding_requirements.present? && q.corresponding_requirements.include?(requirement.requirement_identifier) }.count

      amount += answers.select { |a| a.corresponding_requirements.present? && a.corresponding_requirements.include?(requirement.requirement_identifier)}.count

      if amount == 0
        errors.add(:base, "requirement '#{requirement.requirement_identifier}' is not linked to a question or answer")
      elsif amount > 1
        errors.add(:base, "requirement '#{requirement.requirement_identifier}' is linked more than one question or answer")
      end
    end
  end

  def remove_blank_translations(source)
    source.inject({}) do |result, (k,v)|
      result[k] = (v.is_a?(Hash) ? remove_blank_translations(v) : v) unless v.blank?
      result
    end
  end

end
