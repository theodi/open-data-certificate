class Question < ActiveRecord::Base
  include Surveyor::Models::QuestionMethods

  attr_accessible :improvement

  def improvement_level
    #TODO: Create an association to a model for Improvements? Or just leave it as a text key for the translations?
    improvement.to_s.match(/^[a-zA-Z]*/).to_s
  end

end
