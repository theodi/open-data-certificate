class CertificationCampaign < ActiveRecord::Base
  include Ownership
  validates :name, uniqueness: true, presence: true

  has_many :certificate_generators
  belongs_to :user

  attr_accessible :name

  def total_count
    generated_count + duplicate_count
  end

  def generated_count
    certificate_generators.count
  end

  def published_count
    certificate_generators.joins(:certificate).merge(Certificate.published).count
  end

  def rerun!
    certificate_generators.each do |c|
      dataset = Dataset.find(c.dataset.id)
      CertificateGenerator.update(dataset, nil, c.survey.access_code, user)
    end
  end

end
