class Response < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include Surveyor::Models::ResponseMethods

  attr_accessible :autocompleted

  # override with :touch
  belongs_to :response_set, touch: true

  after_save :set_default_dataset_title
  after_save :update_survey_section_id

  def statement_text
    answer.try(:text_as_statement) || to_formatted_s
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

  private
  def set_default_dataset_title
    dataset.try(:set_default_title!, response_set.title_determined_from_responses)
  end

  private
  def update_survey_section_id
    if survey_section_id.blank?
      survey_section_id = question.try(:survey_section_id)
      Response.update(id, :survey_section_id => survey_section_id) if survey_section_id
    end
  end

end
