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
    current.count
  end

  def published_count
    current.joins(:certificate).merge(Certificate.published).count
  end

  def current
    certificate_generators.where(latest: true)
  end

  def rerun!
    certificate_generators.each do |c|
      dataset = Dataset.find(c.dataset.id)
      generator = CertificateGenerator.create(
        request: c.request,
        user: user,
        certification_campaign: self
      )
      generator.sidekiq_delay.generate(c.survey.access_code, true, dataset)
    end
  end

end
