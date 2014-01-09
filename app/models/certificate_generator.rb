class CertificateGenerator < ActiveRecord::Base

  attr_readonly :request

  belongs_to :user
  belongs_to :response_set
  has_one :certificate, through: :response_set
  has_one :survey, through: :response_set

  TYPES =  {
    none: 'string',
    one: 'radio',
    any: 'checkbox',
    repeater: 'repeating'
  }

  def self.schema(request)
    survey = Survey.newest_survey_for_access_code request['jurisdiction']
    return {errors: ['Jurisdiction not found']} if !survey

    schema = {}
    survey.questions.each do |q|
      next if q.display_type == 'label'
      type = q.question_group && q.question_group.display_type == 'repeater' ? :repeater : q.pick.to_sym
      schema[q.reference_identifier] = question = {question: q.text, type: TYPES[type], required: q.is_mandatory}

      if type == :one || type == :any
        question['options'] = {}
        q.answers.each{|a| question['options'][a.reference_identifier] = a.text }
      end

      question
    end

    {schema: schema}
  end

  # attempt to build a certificate from the request
  def self.generate(request)

    survey = Survey.newest_survey_for_access_code request[:jurisdiction]
    return {success: false, errors: ['Jurisdiction not found']} if !survey

    certificate = self.create(request: request).generate(survey)

    response_set = certificate.response_set
    mandatory_complete = response_set.all_mandatory_questions_complete?
    urls_resolve = response_set.all_urls_resolve?
    if published = mandatory_complete && urls_resolve
      response_set.complete!
      response_set.save
    end

    errors = certificate.errors.to_a

    response_set.responses_with_url_type.each do |response|
      if response.error
        errors.push("The question '#{response.question.reference_identifier}' must have a valid URL")
      end
    end

    survey.questions.where(is_mandatory: true).each do |question|
      response = response_set.responses.detect {|r| r.question_id == question.id}

      if !response || (question.pick == "none" ? response.string_value.blank? : !response.answer_id)
        errors.push("The question '#{question.reference_identifier}' is mandatory")
      end
    end

    {success: certificate.valid?, published: published, errors: errors}
  end

  def generate(survey)
    create_response_set(survey: survey)

    # find the questions which are to be answered
    survey.questions
          .where({reference_identifier: request_dataset.keys})
          .includes(:answers)
          .each {|question| answer question}

    response_set.publish! if response_set.may_publish?

    certificate
  end

  private

  # the dataset parameters from the request, defaults to {}
  def request_dataset
    HashWithIndifferentAccess.new request[:dataset]
  end

  # answer a question from the request
  def answer question

    # find the value that should be entered
    value = request_dataset[question[:reference_identifier]]

    response_set.responses.where(question_id: question).delete_all

    case question.pick

    when 'none'
      answer = question.answers.first
      response_set.responses.create({
        answer: answer,
        question: question,
        string_value: value
      })

    when 'one'
      # the value is the reference identifier of the target answer
      answer = question.answers.where(reference_identifier: value).first

      unless answer.nil?
        response_set.responses.create({
          answer: answer,
          question: question
        })
      end

    when 'any'
      # the value is an array of the chosen answers
      answers = question.answers.where(reference_identifier: value)
      answers.each do |answer|
        response_set.responses.create({
          answer: answer,
          question: question
        })
      end

    else
      throw "not handled> #{question.inspect}"
    end

  end

end

