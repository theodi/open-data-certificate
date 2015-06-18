class MissingResponse < ActiveRecord::Base
  belongs_to :response_set
  has_one :question
end
