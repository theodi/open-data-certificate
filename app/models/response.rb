class Response < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include Surveyor::Models::ResponseMethods

  attr_writer :reference_identifier
  attr_accessible :autocompleted

  # override with :touch
  belongs_to :response_set, touch: true

  after_save :set_default_dataset_title, :set_default_documentation_url
  after_save :update_survey_section_id

  # gets all responses in the same response set for a question, useful for checkbox questions
  def sibling_responses
    @sibling_responses ||= Response.where(question_id: question_id, response_set_id: response_set_id)
  end

  def statement_text
    answer.try(:text_as_statement) || to_formatted_s
  end

  def reference_identifier
    @reference_identifier ||= answer.reference_identifier
  end

  def requirement_level
    @requirement_level ||= answer.requirement_level
  end

  def requirement
    @requirement ||= answer.requirement
  end

  def requirement_level_index
    @requirement_level_index ||= Survey::REQUIREMENT_LEVELS.index(requirement_level)
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
    @auto_value ||= response_set.kitten_data ? response_set.kitten_data.fields[question.reference_identifier] : nil
  end

  def formatted_auto_value
    auto_value.kind_of?(Array) ? auto_value.try(:join, ',') : auto_value
  end

  def autocompletable?
    !!(auto_value && !auto_value.empty?)
  end

  def any_metadata_missing
    @any_metadata_missing ||= question.metadata_field? && sibling_responses.select(&:metadata_missing).any?
  end

  def metadata_missing
    @metadata_missing ||= question.metadata_field? && autocompletable? && !autocompleted && answer
  end

  def all_autocompleted
    if question.pick == 'any' && autocompletable?
      return @all_autocompleted ||= sibling_responses.map(&:reference_identifier).sort == auto_value.sort
    end

    @all_autocompleted ||= autocompleted
  end

  def autocompleted
    @autocompleted ||= compute_autocompleted
  end

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
