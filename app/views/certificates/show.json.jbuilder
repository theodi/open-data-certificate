json.certificate do |certificate|
	certificate.title @certificate.response_set.title
	certificate.jurisdiction do |jurisdiction|
		jurisdiction.label @certificate.response_set.jurisdiction
		jurisdiction.uri prefixes[:jurisdiction][@certificate.response_set.jurisdiction.downcase].to_s
	end
	certificate.level do |level|
		level.label @certificate.attained_level.titleize
		level.uri prefixes[:cert]["#{@certificate.attained_level.titleize}Certificate"].to_s
	end
	certificate.created_at @certificate.created_at

  responses = get_responses(@certificate)

  certificate.responses responses do |json, response|
    json.question do |question|
      question.text response.question.text
      question.uri question = RDF::URI.new("https://certificates.theodi.org/surveys/questions/#{response.question.id}").to_s
    end
    json.answer do |answer|
      answer.text response.question.text_as_statement + " " + response.statement_text
    end
  end
end