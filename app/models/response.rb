class Response < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include Surveyor::Models::ResponseMethods

  after_save :set_default_dataset_title

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

end
