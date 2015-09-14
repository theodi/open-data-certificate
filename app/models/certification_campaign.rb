class CertificationCampaign < ActiveRecord::Base
  include Ownership

  attr_accessor :version
  attr_writer :limit

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
    certificate_generators.update_all(latest: false)
    CertificateFactory::FactoryRunner.perform_async(campaign_id: id, feed: url, jurisdiction: jurisdiction, user_id: user.id)
  end

  def validate_extra_details?
    version.to_i > 1
  end

  def limit
    @limit.to_i unless @limit.blank?
  end

  def scheduled_rerun
    rerun!
  ensure
    CertificationCampaignWorker.perform_in(1.day, id)
  end

  def determine_jurisdiction
    [
      jurisdiction.presence,
      certificate_generators.first.try(:survey).try(:access_code),
      user.try(:default_jurisdiction).presence,
      'gb'
    ].compact.first
  end

end
