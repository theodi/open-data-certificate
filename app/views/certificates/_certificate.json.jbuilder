responses = cert.get_responses
json.title "Open Data Certificate for #{cert.response_set.title}"
json.uri dataset_certificate_url(cert.dataset, cert)
json.dataset do |dataset|
  dataset.title cert.response_set.title
  dataset.publisher cert.response_set.dataset_curator_determined_from_responses
  dataset.uri dataset_url(cert.dataset)
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