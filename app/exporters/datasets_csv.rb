class DatasetsCSV
  include ApplicationHelper

  attr_reader :datasets

  def initialize(datasets)
    @datasets = datasets
  end

  def each
    yield CSV.generate_line(headers)
    datasets.find_each do |dataset|
      yield CSV.generate_line(row(dataset))
    end
  end

  def save(filename)
    File.open(filename, 'w') do |f|
      each do |row|
        f.write(row)
      end
    end
  end

  def row(dataset)
    certificate = dataset.certificate
    response_set = certificate.response_set
    [
      "Open Data Certificate for #{response_set.title}",
      url(:dataset_latest_certificate_url, dataset),
      response_set.jurisdiction,
      response_set.survey.try(:status),
      I18n.t("levels.#{certificate.attained_level}.title").downcase,
      certificate.created_at,
      I18n.t(certificate.certification_type, scope: 'certificate.certification_types'),
      url(:badge_dataset_latest_certificate_url, dataset, :format => "js"),
      url(:badge_dataset_latest_certificate_url, dataset, :format => "html"),
      url(:badge_dataset_latest_certificate_url, dataset, :format => "png"),
      response_set.title,
      url(:dataset_url, dataset),
      response_set.dataset_curator_determined_from_responses,
      response_set.data_licence_determined_from_responses[:url],
      response_set.content_licence_determined_from_responses[:url],
      (response_set.documentation_url.data_value if response_set.documentation_url)
    ]
  end

  def url(name, dataset, params={})
    params = {
      host: OpenDataCertificate.hostname,
      protocol: Rails.env.production? ? 'https' : 'http',
      locale: I18n.locale
    }.merge(params)
    Rails.application.routes.url_helpers.send(name, dataset, params)
  end

  def headers
    %w[
      title
      url
      jurisdiction
      status
      level
      created_at
      certification_type
      badge_javascript
      badge_html
      badge_image
      dataset_title
      dataset_url
      publisher
      data_license
      content_license
      documentation_url
    ]
  end
end
