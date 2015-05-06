class Answer < ActiveRecord::Base
  include Surveyor::Models::AnswerMethods

  attr_accessible :requirement, :help_text_more_url, :input_type, :placeholder, :text_as_statement

  scope :urls, where(:input_type => 'url')

  def message?
    !(message || '').strip.blank?
  end

  def requirement
    @requirement ||= read_attribute(:requirement).presence || question.try(:requirement).presence
  end

  def requirement_level
    #TODO: Create an association to a model for Improvements? Or just leave it as a text key for the translations?
    requirement.to_s.match(/^[a-zA-Z]*/).to_s
  end

  def requirement_level_index
    Survey::REQUIREMENT_LEVELS.index(requirement_level)
  end

  def placeholder_for(context = nil, locale = nil)
    in_context(translation(locale)[:placeholder], context)
  end

  def translation(locale)
    {:text => self.text,
     :help_text => self.help_text,
     :default_value => self.default_value,
     :placeholder => self.placeholder,
    }.with_indifferent_access
  end

  def value_key
    input_type == 'url' ? :text_value : :string_value
  end
end
