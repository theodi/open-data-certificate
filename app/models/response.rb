class Response < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include Surveyor::Models::ResponseMethods
  extend Memoist

  attr_writer :reference_identifier
  attr_accessible :autocompleted

  # override with :touch
  belongs_to :response_set, touch: true

  after_save :set_default_dataset_title, :set_default_documentation_url
  after_save :update_survey_section_id

  def sibling_responses(responses)
    (responses || []).select{|r| r.question_id == question_id && r.response_set_id == response_set_id}
  end
  memoize :sibling_responses

  def statement_text
    answer.try(:text_as_statement) || to_formatted_s
  end

  def reference_identifier
    answer.try(:reference_identifier)
  end
  memoize :reference_identifier

  def requirement_level
    answer.requirement_level
  end
  memoize :requirement_level

  def requirement
    answer.requirement
  end
  memoize :requirement

  def requirement_level_index
    Survey::REQUIREMENT_LEVELS.index(requirement_level)
  end
  memoize :requirement_level_index

  def empty?
    question.pick == "none" ? string_value.blank? : !answer_id
  end

  def filled?
    !empty?
  end

  def ui_hash_values
    [:datetime_value, :integer_value, :float_value, :unit, :text_value, :string_value, :response_other].reduce({}) do |memo, key|
      value = self.send(key)
      memo[key] = value unless value.blank?
      memo
    end
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
    !!(auto_value && !auto_value.empty?)
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
        return string_value == auto_value
      end

      if question.pick == 'one'
        return answer && auto_value == answer.reference_identifier
      end

      if question.pick == 'any'
        return (!answer && !auto_value.include?(reference_identifier)) || (answer && auto_value.include?(answer.reference_identifier))
      end
    end
  end

  private
  def set_default_dataset_title
    dataset.try(:set_default_title!, response_set.dataset_title_determined_from_responses)
  end

  def set_default_documentation_url
    dataset.try(:set_default_documentation_url!, response_set.dataset_documentation_url_determined_from_responses)
  end

  def update_survey_section_id
    if survey_section_id.blank?
      survey_section_id = question.try(:survey_section_id)
      Response.update(id, :survey_section_id => survey_section_id) if survey_section_id
    end
  end

end
