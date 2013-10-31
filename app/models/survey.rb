class Survey < ActiveRecord::Base
  include Surveyor::Models::SurveyMethods

  serialize :meta_map, Hash

  STATUSES = %w(alpha beta final)

  REQUIREMENT_LEVELS = %w(none basic pilot standard exemplar)

  # this is access_codes of surveys that we want the user to move from->to
  MIGRATIONS = {'open-data-certificate-questionnaire' => 'gb'}

  # temorary - when we have the jurisdiction choice at the start, this won't be needed
  DEFAULT_ACCESS_CODE = 'gb'

  validate :ensure_requirements_are_linked_to_only_one_question_or_answer
  attr_accessible :full_title, :meta_map, :status, :default_locale_name

  has_many :response_sets

  has_many :questions, :through => :sections, :include => {:dependency => :dependency_conditions}
  has_many :dependencies, :through => :questions

  class << self

    def available_to_complete
      order('access_code DESC, survey_version DESC').group(:access_code)
    end

    def newest_survey_for_access_code(access_code)
      where(access_code: access_code).order("surveys.survey_version DESC").first
    end

  end

  def previous_surveys
    Survey.where(access_code: access_code).where(Survey.arel_table[:survey_version].lt(survey_version))
  end

  def previous_survey
    @previous_survey ||= Survey.where(access_code: access_code, survey_version: survey_version - 1).first
  end

  def status_incremented?
    previous_survey ? STATUSES.index(status) > STATUSES.index(previous_survey.status) : false
  end

  def set_expired_certificates
    if status_incremented?
      Certificate.set_expired(previous_surveys)
    end
  end

  def metadata_fields
    Set.new ['copyrightStatementMetadata', 'documentationMetadata', 'distributionMetadata']
  end

  def meta_map
    meta = read_attribute(:meta_map)
    map.each { |attr, val| meta[attr.to_sym] ||= val }
    meta
  end

  def map
    {
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
  end

  def superceded?
    !(self.id == Survey.newest_survey_for_access_code(access_code).try(:id))
  end

  def requirements
    # questions.select(&:is_a_requirement?)
    questions.where(display_type: 'label').where('requirement > ""')
  end

  def only_questions
    questions.where('display_type != "label" OR requirement = ""')
  end

  def mandatory_questions
    questions.where(:is_mandatory => true)
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

  ### override surveyor methods

  def translation(locale_symbol)
    {:title => self.title, :description => self.description}.with_indifferent_access.merge(trns(locale_symbol))
  end

  # prevent the translations from being loaded all the time
  def trns(locale_symbol)
    return @trns unless @trns.nil?
    t = self.translations.where(:locale => locale_symbol.to_s).first
    @trns = t ? YAML.load(t.translation || "{}").with_indifferent_access : {}
  end

  ### /override surveyor methods

  private

  def ensure_requirements_are_linked_to_only_one_question_or_answer
    # can't rely on the methods for these collections, as for new surveys nothing will be persisted to DB yet
    questions = sections.map(&:questions).flatten.compact
    requirements = questions.select(&:is_a_requirement?)
    only_questions = (questions - requirements)
    answers = only_questions.map(&:answers).flatten.compact

    requirements.each do |requirement|
      amount = only_questions.select { |q| q != requirement && q.requirement && q.requirement.include?(requirement.requirement) }.count + answers.select { |a| a.requirement && a.requirement.include?(requirement.requirement)}.count
      if amount == 0
        errors.add(:base, "requirement '#{requirement.reference_identifier}' is not linked to a question or answer")
      elsif amount > 1
        errors.add(:base, "requirement '#{requirement.reference_identifier}' is linked more than one question or answer")
      end
    end
  end

end
