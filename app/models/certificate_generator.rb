class CertificateGenerator < ActiveRecord::Base
  include Ownership

  belongs_to :user
  belongs_to :response_set, :inverse_of => :certificate_generator
  belongs_to :certification_campaign

  has_one :dataset, through: :response_set
  has_one :certificate, through: :response_set
  has_one :survey, through: :response_set

  scope :latest, where(latest: true)
  scope :unpublished, joins(:certificate).merge(Certificate.unpublished)
  scope :published, joins(:certificate).merge(Certificate.published)

  before_save :remove_flag

  serialize :request, HashWithIndifferentAccess

  TYPES =  {
    none: 'string',
    one: 'radio',
    any: 'checkbox',
    repeater: 'repeating'
  }

  def self.filter(level)
    case(level)
    when "uncertified"
      joins(:certificate).where(certificates: {attained_level: "none"})
    else
      scoped
    end
  end

  def self.schema(request)
    survey = Survey.newest_survey_for_access_code request['jurisdiction']
    return {errors: ['Jurisdiction not found']} if !survey

    schema = {}
    survey.questions.each do |q|
      next if q.display_type == 'label'
      schema[q.reference_identifier] = question = {question: q.text, type: TYPES[q.type], required: q.mandatory?}

      if q.type == :one || q.type == :any
        question['options'] = {}
        q.answers.each{|a| question['options'][a.reference_identifier] = a.text }
      end

      question
    end

    {schema: schema}
  end

  def self.bulk_update(generator_collection, jurisdiction, user)
    incomplete = 0
    queued = 0
    generator_collection.each do |generator|
      if generator.completed?
        queued+=1
        CertificateGeneratorUpdateWorker.perform_async(generator.id, jurisdiction, user.id)
      else
        incomplete+=1
      end
    end
    return { skipped: incomplete, queued: queued }
  end

  # attempt to build a certificate from the request
  def self.update(dataset, request, jurisdiction, user)

    # Finds a migrated survey if there is one
    survey = Survey.newest_survey_for_access_code Survey::migrate_access_code(jurisdiction)
    return {success: false, errors: ['Jurisdiction not found']} if !survey

    if user.admin?
      response_set = ResponseSet.where(dataset_id: dataset).latest
    else
      response_set = ResponseSet.where(dataset_id: dataset, user_id: user).latest
    end
    return {success: false, errors: ['Dataset not found']} if !response_set

    if survey != response_set.survey || !response_set.modifications_allowed?
      response_set = ResponseSet.clone_response_set(response_set, {survey_id: survey.id, user_id: user.id, dataset_id: response_set.dataset_id})
    end

    generator = response_set.certificate_generator || self.create(response_set: response_set, user: user)
    generator.request = request unless request.nil?

    create_user = user.admin? ? true : false

    certificate = generator.generate(jurisdiction, create_user, dataset)
    response_set = certificate.response_set

    errors = response_set.response_errors

    {success: true, published: response_set.published?, errors: errors}
  end

  def generate(jurisdiction, create_user, dataset = nil)
    unless response_set
      create_response_set(survey: Survey.newest_survey_for_access_code(jurisdiction)) do |rs|
        # dataset is protected against mass assignment
        rs.dataset = dataset if dataset
      end
    end

    # find the questions which are to be answered
    survey.questions
          .where({reference_identifier: request.keys})
          .includes(:answers)
          .each {|question| answer question}

    response_set.autocomplete(autocomplete_url, true)

    user = determine_user(response_set, create_user)
    response_set.assign_to_user!(user)

    if certification_campaign and certification_campaign.template_dataset
      rs = ResponseSet.where(dataset_id: certification_campaign.template_dataset_id).latest
      template_responses = compare_responses(rs)
      adopt_responses(template_responses)
    end

    mandatory_complete = response_set.all_mandatory_questions_complete?
    urls_resolve = response_set.all_urls_resolve?

    if mandatory_complete && urls_resolve
      response_set.complete!
      response_set.publish!
      certificate.update_from_response_set
    else
      response_set.update_missing_responses!
    end

    self.completed = true

    certificate
  ensure
    # because the certificate_generators table has several indexes on it, it is
    # possible for update queries to deadlock each other.  (MySQL updates are
    # not truly atomic and wrapping it in a transaction will not help as it is
    # about lock aquisition for each index row)
    #
    # The only solution is to retry the save query if a deadlock is detected
    save_attempts = 0
    begin
      save!
    rescue ActiveRecord::StatementInvalid => e
      if e.message =~ /deadlock found/i && save_attempts < 10
        save_attempts += 1
        retry
      else
        raise
      end
    end
  end

  def determine_user(response_set, create_user)
    kitten_data = response_set.kitten_data
    if kitten_data
      contacts = kitten_data.contacts_with_email
      contacts.each do |contact|
        user = User.find_by_email(contact.email)
        return user if user.present?
      end
      if create_user
        contacts.each do |contact|
          user = create_user_from_contact(contact)
          return user if user.present?
        end
      end
    end
    return self.user
  end

  def create_user_from_contact(contact)
    User.transaction do
      User.create!(
          email: contact.email,
          name: contact.name,
          password: SecureRandom.base64) do |user|
        user.skip_confirmation_notification!
      end
    end
  # in case the there was a find or create race
  rescue ActiveRecord::RecordNotUnique
    User.find_by_email(contact.email)
  rescue ActiveRecord::RecordInvalid => e
    User.find_by_email(contact.email) if e.message =~ /taken/
  end

  def published?
    certificate.try(:published?)
  end

  def valid_urls?
    response_set.all_urls_resolve?
  end

  def response_errors
    response_set.response_errors
  end

  def dataset_url
    dataset.api_url
  end

  def autocomplete_url
    request["documentationUrl"]
  end

  # the dataset parameters from the request, defaults to {}
  def request=(value)
    write_attribute(:request, value.with_indifferent_access)
  end

  def compare_responses(comparison_response_set)
    answered_questions = response_set.responses.select(:question_id).collect {|r| r.question_id }
    comparison_questions = comparison_response_set.responses.select(:question_id).collect {|r| r.question_id }
    unanswered = comparison_questions - answered_questions
    result = comparison_response_set.responses.where(question_id: unanswered)
    return result
  end

  def adopt_responses(responses)
    adopted = []
    responses.each do |response|
      r = response.dup
      r.response_set = response_set
      r.api_id=nil
      adopted << r if r.save
    end
    adopted
  end

  private

  def remove_flag
    if dataset && certification_campaign
      CertificateGenerator.where("response_sets.dataset_id" => dataset.id, "certification_campaign_id" => certification_campaign.id)
                          .joins(:response_set)
                          .where("certificate_generators.id not in (?)", id)
                          .update_all(latest: false)
    end
  end

  # answer a question from the request
  def answer question

    # find the value that should be entered
    data = request[question[:reference_identifier]]

    response_set.responses.where(question_id: question).delete_all

    case question.type

    when :none
      answer = question.answers.first
      response_set.responses.create({
        answer: answer,
        question: question,
        answer.value_key => data
      })

    when :one
      # the value is the reference identifier of the target answer
      answer = question.answers.where(reference_identifier: data).first

      unless answer.nil?
        response_set.responses.create({
          answer: answer,
          question: question
        })
      end

    when :any
      # the value is an array of the chosen answers
      answers = question.answers.where(reference_identifier: data)
      answers.each do |answer|
        response_set.responses.create({
          answer: answer,
          question: question
        })
      end

    when :repeater
      # the value is an array of answers
      answer = question.answers.first
      i = 0
      data.each do |value|
        response_set.responses.create({
          answer: answer,
          question: question,
          answer.value_key => value,
          response_group: i
        })
        i += 1
      end

    else
      throw "not handled> #{question.inspect}"
    end

  end

end
