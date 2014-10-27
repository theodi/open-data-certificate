class CertificationCampaign < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true

  has_many :certificate_generators
  belongs_to :user

  attr_accessible :name

  def to_param
    name
  end

  def total_count
    generated_count + duplicate_count
  end

  def generated_count
    certificate_generators.count
  end

  def published_count
    certificate_generators.joins(:certificate).merge(Certificate.published).count
  end

end
