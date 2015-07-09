class CertificationCampaign < ActiveRecord::Base
  include Ownership

  attr_accessor :limit, :url, :jurisdiction, :version

  validates :name, uniqueness: true, presence: true
  validates :url, :jurisdiction, presence: true, if: :validate_extra_details?
  validates :limit, numericality: { greater_than: 0 }, allow_blank: true

  has_many :certificate_generators
  belongs_to :user

  attr_accessible :name, :limit, :url, :jurisdiction, :version

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

  def incomplete_count
    current.where(completed: nil).count
  end

  def rerun!
    certificate_generators.each do |c|
      generator = CertificateGenerator.create(
        request: c.request,
        user: user,
        certification_campaign: self
      )
      jurs = if c.survey
        c.survey.access_code
      else
        jurisdiction
      end
      generator.sidekiq_delay.generate(jurs, true, c.dataset)
    end
  end

  def validate_extra_details?
    puts version.to_i
    version.to_i > 1
  end

end
