class AutocompleteOverrideMessage < ActiveRecord::Base
  attr_accessible :message, :question_id, :response_set_id

  belongs_to :question
  belongs_to :response_set
end
