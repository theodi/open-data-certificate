class EmbedStat < ActiveRecord::Base
  belongs_to :dataset

  delegate :title, :to => :dataset, :prefix => true, :allow_nil => true

  attr_accessible :referer

  validates :referer, url: true
  validates_uniqueness_of :referer, :scope => :dataset_id

  def self.csv
    CSV.generate(row_sep: "\r\n") do |csv|
      csv << ["Dataset Name", "Dataset URL", "Referring URL", "First Detected"]
      all.each { |s| csv << [s.dataset_title, s.dataset_path, s.referer, s.created_at] }
    end
  end

  def self.unique_domains
    all.group_by { |e| e.host }.count
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
      Rails.application.routes.url_helpers.dataset_url(dataset, host: OpenDataCertificate.hostname)
    end
  end

end
