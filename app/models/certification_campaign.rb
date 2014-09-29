class CertificationCampaign < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true

  has_many :certificate_generators
  belongs_to :user

  attr_accessible :name

  def to_param
    name
  end

end
