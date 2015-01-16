class DatasetsCSV
  include ApplicationHelper

  attr_reader :datasets, :controller

  def initialize(datasets, controller)
    @datasets = datasets
    @controller = controller
  end

  def each
    yield CSV.generate_line(headers)
    datasets.find_each do |dataset|
      yield CSV.generate_line(row(dataset))
    end
  end

  def request
    controller.request
  end

  def row(dataset)
    certificate = dataset.certificate
    response_set = certificate.response_set
    [
      "Open Data Certificate for #{response_set.title}",
      controller.dataset_latest_certificate_url(dataset, :protocol => embed_protocol),
      response_set.jurisdiction,
      response_set.survey.try(:status),
      I18n.t("levels.#{certificate.attained_level}.title").downcase,
      certificate.created_at,
      I18n.t(certificate.certification_type, scope: 'certificate.certification_types'),
      controller.badge_dataset_latest_certificate_url(dataset, :format => "js", :protocol => embed_protocol),
      controller.badge_dataset_latest_certificate_url(dataset, :format => "html", :protocol => embed_protocol),
      controller.badge_dataset_latest_certificate_url(dataset, :format => "png", :protocol => embed_protocol),
      response_set.title,
      response_set.dataset_curator_determined_from_responses,
      controller.dataset_url(dataset, :protocol => embed_protocol),
      response_set.data_licence_determined_from_responses[:url],
      response_set.content_licence_determined_from_responses[:url],
      (response_set.documentation_url.string_value if response_set.documentation_url)
    ]
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
