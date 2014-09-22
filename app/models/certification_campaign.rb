class CertificationCampaign < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true

  has_many :certificate_generators

  attr_accessible :name
end
