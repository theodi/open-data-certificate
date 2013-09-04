responses = get_responses(@certificate)

json.version 0.1
json.license "http://opendatacommons.org/licenses/odbl/"
json.certificate do |certificate|
	certificate.title "Open Data Certificate for #{@certificate.response_set.title}"
	certificate.uri dataset_certificate_url(@certificate.dataset, @certificate)
	certificate.dataset do |dataset|
	  dataset.title @certificate.response_set.title
	  dataset.publisher @certificate.response_set.dataset_curator_determined_from_responses
	  dataset.uri dataset_url(@certificate.dataset)
    dataset.dataLicense @certificate.response_set.data_licence_determined_from_responses[:url]
    dataset.contentLicense @certificate.response_set.content_licence_determined_from_responses[:url]
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
	certificate.jurisdiction @certificate.response_set.jurisdiction
	certificate.level @certificate.attained_level.titleize
	certificate.created_at @certificate.created_at
end