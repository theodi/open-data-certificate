class Response < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include Surveyor::Models::ResponseMethods
  extend Memoist

  attr_writer :reference_identifier
  attr_accessible :autocompleted, :explanation

  belongs_to :response_set, touch: true, inverse_of: :responses
  belongs_to :question, :inverse_of => :responses
  belongs_to :answer, :inverse_of => :responses

  before_save :resolve_if_url

  scope :filled, joins(:question).where(<<-SQL)
    CASE questions.pick
    WHEN 'none' THEN (trim(string_value) != '' OR trim(text_value) != '')
    ELSE answer_id is not null
    END
  SQL

  scope :for_id, lambda { |id| joins(:question).merge(Question.for_id(id)) }

  def sibling_responses(responses)
    (responses || []).select{|r| r.question_id == question_id && r.response_set_id == response_set_id}
  end
  memoize :sibling_responses

  def statement_text
    answer.statement_text.presence || to_formatted_s
  end

  def reference_identifier
    answer.try(:reference_identifier)
  end
  memoize :reference_identifier

  def requirement_level
    answer.requirement_level
  end
  memoize :requirement_level

  def requirement_level_index
    Survey::REQUIREMENT_LEVELS.index(requirement_level)
  end
  memoize :requirement_level_index

  def empty?
    question.pick == "none" ? data_value.blank? : !answer_id
  end

  def filled?
    !empty?
  end

  def ui_hash_values
    values = [:datetime_value, :integer_value, :float_value, :unit, :text_value, :string_value, :response_other, :response_group, :explanation].reduce({}) do |memo, key|
      value = self.send(key)
      memo[key] = value unless value.blank?
      memo
    end
    if answer.response_class == 'text'
      values[:text_value] ||= values[:string_value]
    end
    return values
  end

  def dataset
    response_set.try(:dataset)
  end

  def auto_value
    response_set.kitten_data ? response_set.kitten_data.fields[question.reference_identifier] : nil
  end
  memoize :auto_value

  def formatted_auto_value
    auto_value.kind_of?(Array) ? auto_value.try(:join, ',') : auto_value
  end

  def autocompletable?
    auto_value.present?
  end

  def any_metadata_missing(responses)
    question.metadata_field? && sibling_responses(responses).select(&:metadata_missing).any?
  end
  memoize :any_metadata_missing

  def metadata_missing
    question.metadata_field? && autocompletable? && !autocompleted && answer
  end
  memoize :metadata_missing

  def all_autocompleted(responses)
    if question.pick == 'any' && autocompletable?
      return @all_autocompleted ||= sibling_responses(responses).map(&:reference_identifier).sort.uniq == auto_value.sort.uniq
    end

    @all_autocompleted ||= autocompleted
  end

  def autocompleted
    compute_autocompleted
  end
  memoize :autocompleted

  def compute_autocompleted
    if autocompletable?
      if question.pick == 'none'
        return data_value == auto_value
      end

      if question.pick == 'one'
        return answer && auto_value == answer.reference_identifier
      end

      if question.pick == 'any'
        return (!answer && !auto_value.include?(reference_identifier)) || (answer && auto_value.include?(answer.reference_identifier))
      end
    end
  end

  def url_valid_or_explained?
    !error || explained?
  end

  def explained?
    explanation.present?
  end

  def data_value
    text_value.presence || string_value.presence
  end

  private
  def resolve_if_url
    return unless answer.present? && answer.input_type == 'url' && data_value.present?
    self.error = !ODIBot.new(data_value).valid?
    return nil # false value will stop active record saving
  end

  def survey
    response_set.survey
  end

  def is_question_for?(attribute)
    survey.question_for_attribute(attribute) == question.reference_identifier
  end

end
