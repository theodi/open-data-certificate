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
      generator = CertificateGenerator.create(
        request: certificate_generators.last.request,
        user: user,
        certification_campaign: self
      )
      generator.sidekiq_delay.generate(c.survey.access_code, true, dataset)
    end
  end

end
