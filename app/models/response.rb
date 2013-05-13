class Response < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include Surveyor::Models::ResponseMethods

  def requirement_level
    @requirement_level ||= answer.requirement_level
  end

  def requirement_level_index
    @requirement_level_index ||= Survey::REQUIREMENT_LEVELS.index(requirement_level)
  end

end
