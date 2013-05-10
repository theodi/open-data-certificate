class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods

  def incomplete!
    update_attribute :completed_at, nil
  end

  def triggered_mandatory_questions
    self.survey.mandatory_questions.select{|q|q.triggered?(self)}
  end

  def triggered_requirements
    survey.requirements.select{|r|r.triggered?(self)}
  end

  def attained_level
    Survey::REQUIREMENT_LEVELS[minimum_attained_requirement_level]
  end

  def minimum_attained_requirement_level
    ((triggered_requirements - completed_requirements).map(&:requirement_level_index) << Survey::REQUIREMENT_LEVELS.size-1).min
  end

  def completed_requirements
    triggered_requirements.select{|r|r.requirement_met_by_responses?(self.responses)}
  end

end