class Answer < ActiveRecord::Base
  include Surveyor::Models::AnswerMethods

  attr_accessible :requirement

  def improvement_level
    #TODO: Create an association to a model for Improvements? Or just leave it as a text key for the translations?
    requirement.to_s.match(/^[a-zA-Z]*/).to_s
  end

end
