class EmbedStat < ActiveRecord::Base
  belongs_to :dataset

  delegate :title, :to => :dataset, :prefix => true, :allow_nil => true

  attr_accessible :referer

  validates :referer, url: true
  validates_uniqueness_of :referer, :scope => :dataset_id

  before_save :extract_domain

  def self.csv
    CSV.generate(row_sep: "\r\n") do |csv|
      csv << ["Dataset Name", "Dataset URL", "Referring URL", "First Detected"]
      includes(:dataset).find_each do |s|
        csv << [s.dataset_title, s.dataset_path, s.referer, s.created_at]
      end
    end
  end

  def self.unique_domains
    count('distinct domain')
  end

  def self.unique_datasets
    count('distinct dataset_id')
  end

  def host
    URI.parse(URI.escape(referer)).host
  rescue URI::InvalidURIError => e
    nil
  end

  def dataset_path
    if dataset
      Rails.application.routes.url_helpers.dataset_url(dataset, host: OpenDataCertificate.hostname, locale: I18n.locale)
    end
  end

  def extract_domain
    self.domain = host || 'invalid-domain'
  end

end
