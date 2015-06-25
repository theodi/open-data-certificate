class CertificationCampaign < ActiveRecord::Base
  include Ownership

  attr_accessor :jurisdiction, :version
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

    if url.present?
      factory = CertificateFactory::Factory.new(feed: url)
      factory.each do |item|
        url = factory.get_link(item)
        existing_generator = certificate_generators.select { |g| g.request["documentationUrl"] == url }.first
        request = existing_generator.try(:request) || build_request(url)
        run_generator(request, certificate_generators.first.survey.access_code, existing_generator.try(:dataset))
      end
    else
      certificate_generators.each do |c|
        dataset = Dataset.find(c.dataset.id)
        jurs = if c.survey
          c.survey.access_code
        else
          jurisdiction
        end
        run_generator(c.request, jurs, dataset)
      end
    end
  end

  def build_request(url)
    {
      documentationUrl: url
    }
  end

  def validate_extra_details?
    version.to_i > 1
  end

  def limit
    @limit.to_i unless @limit.blank?
  end

  def run_generator(request, access_code, dataset)
    generator = CertificateGenerator.create(
      request: request,
      user: user,
      certification_campaign: self
    )
    generator.sidekiq_delay.generate(access_code, true, dataset)
  end

end
