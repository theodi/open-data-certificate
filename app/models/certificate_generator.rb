class CertificateGenerator < ActiveRecord::Base

  attr_readonly :request

  belongs_to :user
  belongs_to :response_set
  has_one :certificate, through: :response_set
  has_one :survey, through: :response_set

  after_create :generate
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
  def generate

    s = Survey.newest_survey_for_access_code request[:jurisdiction]

    create_response_set(survey: s)

    # find the questions which are to be answered
    survey.questions
          .where({reference_identifier: request_dataset.keys})
          .includes(:answers)
          .all.each {|question| answer question}

    response_set.publish! if response_set.may_publish?

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

    case question.pick
    when 'none'
      response_set.responses.create({
        string_value: value,
        question: question
      })
    when 'one'
      # the value is the reference identifier of the target answer 
      answer = question.answers.where(reference_identifier: value).first
      
      unless answer.nil?
        response_set.responses.create({
          answer_id: answer.id,
          question: question
        })
      end
    when 'many'

      # the value is an array of the answers
      answers = question.answers.where(reference_identifier: value)
      answers.each do |answer|
        response_set.responses.create({
          answer_id: answer.id,
          question: question
        })
      end

    else 
      throw "not handled> #{question.inspect}"
    end

  end

end


