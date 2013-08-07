json.certificate do |certificate|
	certificate.title "Open Data Certificate for #{@certificate.response_set.title}"
	certificate.dataset do |dataset|
	  dataset.title @certificate.response_set.title
	  dataset.publisher @certificate.response_set.curator_determined_from_responses
	  dataset.dataLicence @certificate.response_set.data_licence_determined_from_responses[:url]
	  dataset.contentLicence @certificate.response_set.content_licence_determined_from_responses[:url]
	  dataset.uri dataset_url(@certificate.dataset)
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

  responses = get_responses(@certificate)
  
  certificate.answers do |answer|
    responses.each do |response|
      answer.set! response.question.reference_identifier, response.statement_text
    end
  end
end