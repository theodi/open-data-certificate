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
    if response.count == 1
      response = response[0]
      if response.question.pick == 'none'
        if response.answer.input_type == 'url'
          dataset.set! response.question.reference_identifier, response.statement_text
        else
          dataset.set! response.question.reference_identifier, response.statement_text
        end
      elsif response.question.pick == 'one'
        if response.answer.reference_identifier =~ /false|true/ && response.question.answers.count == 2
          dataset.set! response.question.reference_identifier, !!(response.answer.reference_identifier == "true")
        elsif response.question.reference_identifier !~ /dataLicence|contentLicence/
          dataset.set! response.question.reference_identifier, response.answer.reference_identifier
        end
      end  
    else
      resps = []
      response.each do |r|
        resps << r.answer.reference_identifier
      end
      dataset.set! response[0].question.reference_identifier, resps
    end      
  end
end
json.jurisdiction cert.response_set.jurisdiction
json.level cert.attained_level.titleize
json.created_at cert.created_at