responses = cert.get_responses
json.title "Open Data Certificate for #{cert.response_set.title}"
json.uri cert.url(:protocol => embed_protocol)
json.jurisdiction cert.response_set.jurisdiction
json.status cert.response_set.survey.try(:status)
json.certification_type t(cert.certification_type, scope: 'certificate.certification_types')
json.badges do |badge|
  if cert.latest?
    badge.set! "application/javascript", badge_dataset_latest_certificate_url(cert.dataset, :format => "js", :protocol => embed_protocol)
    badge.set! "text/html", badge_dataset_latest_certificate_url(cert.dataset, :format => "html", :protocol => embed_protocol)
    badge.set! "image/png", badge_dataset_latest_certificate_url(cert.dataset, :format => "png", :protocol => embed_protocol)
  else
    badge.set! "application/javascript", badge_dataset_certificate_url(cert.dataset, cert, :format => "js", :protocol => embed_protocol)
    badge.set! "text/html", badge_dataset_certificate_url(cert.dataset, cert, :format => "html", :protocol => embed_protocol)
    badge.set! "image/png", badge_dataset_certificate_url(cert.dataset, cert, :format => "png", :protocol => embed_protocol)
  end
end
json.dataset do |dataset|
  dataset.title cert.response_set.title
  dataset.publisher cert.response_set.dataset_curator_determined_from_responses
  dataset.uri dataset_url(cert.dataset, :protocol => embed_protocol)
  dataset.dataLicense cert.response_set.data_licence_determined_from_responses[:url]
  dataset.contentLicense cert.response_set.content_licence_determined_from_responses[:url]
  responses.each do |k, response|
    resps = []
    response.each do |r|
      if r.question.pick == 'none'
        resps << r.statement_text
      elsif r.question.pick == 'one'
        if r.answer.reference_identifier =~ /false|true/ && r.question.answers.count == 2
          resps << !!(r.answer.reference_identifier == "true")
        elsif r.question.reference_identifier !~ /dataLicence|contentLicence/
          resps << r.answer.reference_identifier
        end
      else
        resps << r.answer.reference_identifier
      end  
    end
    if resps.count == 1
      dataset.set! response[0].question.reference_identifier, resps[0]
    elsif resps.count > 1
      dataset.set! response[0].question.reference_identifier, resps
    end
  end
end
json.jurisdiction cert.response_set.jurisdiction
json.level t("levels.#{cert.attained_level}.title").downcase
json.created_at cert.created_at
