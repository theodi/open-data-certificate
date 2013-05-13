class Dataset < ActiveRecord::Base
  belongs_to :user

  has_many :response_sets  
end
