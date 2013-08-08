responses = get_responses(@certificate)

json.certificate do |certificate|
	certificate.title "Open Data Certificate for #{@certificate.response_set.title}"
	certificate.dataset do |dataset|
	  dataset.title @certificate.response_set.title
	  dataset.publisher @certificate.response_set.curator_determined_from_responses
	  dataset.dataLicence @certificate.response_set.data_licence_determined_from_responses[:url]
	  dataset.contentLicence @certificate.response_set.content_licence_determined_from_responses[:url]
	  dataset.uri dataset_url(@certificate.dataset)
	  responses.each do |k, response|
      if response.count == 1
        if response[0].question.pick == 'none'
          if response[0].answer.input_type == 'url'
            dataset.set! response[0].question.reference_identifier, response[0].statement_text
          else
            dataset.set! response[0].question.reference_identifier, response[0].statement_text
          end
        elsif response[0].question.pick == 'one'
          if response[0].answer.reference_identifier =~ /false|true/
            dataset.set! response[0].question.reference_identifier, !!(response[0].answer.reference_identifier == "true")
          else
            dataset.set! response[0].question.reference_identifier, "http://schema.theodi.org/certificate/question/#{response[0].question.reference_identifier}/answer/#{response[0].answer.reference_identifier}"
          end
        end  
      else
        resps = []
        response.each do |r|
          resps << "http://schema.theodi.org/certificate/question/#{r.question.reference_identifier}/answer/#{r.answer.reference_identifier}"
        end
        dataset.set! response[0].question.reference_identifier, resps
      end      
    end
  end
	certificate.jurisdiction do |jurisdiction|
		jurisdiction.label @certificate.response_set.jurisdiction
		jurisdiction.uri "http://ontologi.es/place/" + @certificate.response_set.jurisdiction
	end
	certificate.level do |level|
		level.label @certificate.attained_level.titleize
		level.uri prefixes[:cert]["#{@certificate.attained_level.titleize}Certificate"].to_s
	end
	certificate.created_at @certificate.created_at
end