class Answer < ActiveRecord::Base
  include Surveyor::Models::AnswerMethods

  attr_accessible :corresponding_requirements, :help_text_more_url, :input_type, :placeholder, :text_as_statement

  serialize :corresponding_requirements, Array

  scope :urls, where(:input_type => 'url')
  scope :for_id, lambda { |id| where(reference_identifier: id) }

  def message?
    !(message || '').strip.blank?
  end

  def requirement_level
    corresponding_requirements.first.to_s.match(/^[a-zA-Z]*/).to_s
  end

  def requirement_level_index
    Survey::REQUIREMENT_LEVELS.index(requirement_level)
  end

  def placeholder_for(context = nil, locale = nil)
    in_context(translation(locale)[:placeholder], context)
  end

  def translation(locale)
    default = {
      "text" => text,
      "help_text" => help_text,
      "default_value" => default_value,
      "placeholder" => placeholder
    }

    t = question.translation(locale)[:answers] || {}

    default.merge(
      t[reference_identifier] || t["a_#{reference_identifier}"] || {}
    ).with_indifferent_access
  end

  def answer_text(locale=I18n.locale)
    translation(locale)[:text]
  end

  def statement_text(locale=I18n.locale)
    translation(locale)[:text_as_statement]
  end

  def value_key
    input_type == 'url' ? :text_value : :string_value
  end
end
