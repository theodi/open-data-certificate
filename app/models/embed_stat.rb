class EmbedStat < ActiveRecord::Base
  belongs_to :dataset

  attr_accessible :referer

  validates :referer, url: true
  validates_uniqueness_of :referer, :scope => :dataset_id

  def self.csv
    CSV.generate(row_sep: "\r\n") do |csv|
      csv << ["Dataset Name", "Dataset URL", "Referring URL", "First Detected"]
      all.each { |s| csv << [s.dataset.title, s.dataset_path, s.referer, s.created_at] }
    end
  end

  def self.unique_domains
    all.group_by { |e| URI.parse(URI.escape(e.referer)).host }.count
  end

  def self.unique_datasets
    all.group_by { |e| e.dataset }.count
  end

  def dataset_path
    Rails.application.routes.url_helpers.dataset_url(dataset, host: OpenDataCertificate::Application.config.action_mailer[:default_url_options][:host])
  end

end
