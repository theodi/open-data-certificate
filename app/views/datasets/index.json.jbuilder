json.version 0.1
json.license "http://opendatacommons.org/licenses/odbl/"
json._links do |links|
  @links.each do |rel, href|
    links.set! rel, { href: href }
  end
end

json.certificates do 
  json.array! @datasets do |dataset|
    
    json.title "Open Data Certificate for #{dataset.certificate.response_set.title}"
    json.uri dataset_latest_certificate_url(dataset, :protocol => embed_protocol)
    json.jurisdiction dataset.certificate.response_set.jurisdiction
    json.status dataset.certificate.response_set.survey.try(:status)
    json.certification_type t(dataset.certificate.certification_type, scope: 'certificate.certification_types')
    json.badges do |badge|
      badge.set! "application/javascript", badge_dataset_latest_certificate_url(dataset, :format => "js", :protocol => embed_protocol)
      badge.set! "text/html", badge_dataset_latest_certificate_url(dataset, :format => "html", :protocol => embed_protocol)
      badge.set! "image/png", badge_dataset_latest_certificate_url(dataset, :format => "png", :protocol => embed_protocol)
    end
    json.dataset do
      json.title dataset.certificate.response_set.title
      json.publisher dataset.certificate.response_set.dataset_curator_determined_from_responses
      json.uri dataset_url(dataset, :protocol => embed_protocol)
      json.dataLicense dataset.certificate.response_set.data_licence_determined_from_responses[:url]
      json.contentLicense dataset.certificate.response_set.content_licence_determined_from_responses[:url]
      json.documentationUrl dataset.certificate.response_set.documentation_url.data_value if dataset.certificate.response_set.documentation_url
    end
    json.level t("levels.#{dataset.certificate.attained_level}.title").downcase
    json.created_at dataset.certificate.created_at
  end
  
end
