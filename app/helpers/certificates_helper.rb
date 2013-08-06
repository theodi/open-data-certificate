module CertificatesHelper
  
  def prefixes
    {
      :cc           => RDF::Vocabulary.new("http://creativecommons.org/ns#"),
      :dc           => RDF::Vocabulary.new("http://purl.org/dc/elements/1.1/"),
      :dcat         => RDF::Vocabulary.new("http://www.w3.org/ns/dcat#"),
      :dct          => RDF::Vocabulary.new("http://purl.org/dc/terms/"),
      :foaf         => RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/"),
      :owl          => RDF::Vocabulary.new("http://www.w3.org/2002/07/owl#"),
      :rdf          => RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#"),
      :rdfs         => RDF::Vocabulary.new("http://www.w3.org/2000/01/rdf-schema#"),
      :skos         => RDF::Vocabulary.new("http://www.w3.org/2004/02/skos/core#"),
      :xsd          => RDF::Vocabulary.new("http://www.w3.org/2001/XMLSchema#"),
      :cert         => RDF::Vocabulary.new("http://schema.theodi.org/certificate#"),
      :jurisdiction => RDF::Vocabulary.new("https://certificates.theodi.org/jurisdictions/"),
      :odrs         => RDF::Vocabulary.new("http://schema.theodi.org/odrs#")
    }
  end
  
  def generate_rdf(certificate)
    graph = RDF::Graph.new

    categories = RDF::URI.new("https://certificates.theodi.org/surveys/categories/")

    graph << [categories, RDF.type, prefixes[:skos].ConceptScheme]
    graph << [categories, prefixes[:dct].title, "Categories of questions in Open Data Certificates"]

    general = RDF::URI.new("https://certificates.theodi.org/surveys/categories/general")

    graph << [general, RDF.type, prefixes[:skos].Concept]
    graph << [general, prefixes[:skos].prefLabel, "General Information"]
    graph << [general, prefixes[:skos].inScheme, categories]    
    
    responses = get_responses(certificate)
    
    responses.each do |response|
      question = RDF::URI.new("https://certificates.theodi.org/surveys/questions/#{response.question.id}")
      
      graph << [question, RDF.type, prefixes[:cert].Question]
      graph << [question, prefixes[:rdfs].label, ActionView::Base.full_sanitizer.sanitize(response.question.text)]
      graph << [question, prefixes[:dct].subject, general]
    end
    
    dataset = RDF::URI.new(dataset_url(certificate.dataset))
    od_certificate = RDF::URI.new(dataset_certificate_url(certificate.dataset, certificate))
    
    graph << [dataset, RDF.type, prefixes[:dcat].Dataset]
    graph << [dataset, prefixes[:dct].title, certificate.dataset.title]
    graph << [dataset, prefixes[:foaf].homepage, RDF::URI.new(certificate.dataset.documentation_url)]
    
    publisher = RDF::Node.new
    graph << [dataset, prefixes[:dct].publisher, publisher]
    graph << [publisher, RDF.type, prefixes[:foaf].Organization]
    graph << [publisher, prefixes[:foaf].name, certificate.response_set.curator_determined_from_responses]
    
    rights = RDF::Node.new
    graph << [dataset, prefixes[:dct].rights, rights]
    graph << [rights, RDF.type, prefixes[:odrs].RightsStatement]
    graph << [rights, prefixes[:odrs].dataLicence, RDF::URI.new(certificate.response_set.data_licence_determined_from_responses[:url])]
    graph << [rights, prefixes[:odrs].contentLicence, RDF::URI.new(certificate.response_set.content_licence_determined_from_responses[:url])]
    
    graph << [dataset, prefixes[:cert].certificate, od_certificate]
    
    graph << [od_certificate, RDF.type, prefixes[:cert].Certificate]
    graph << [od_certificate, RDF.type, prefixes[:cert]["#{certificate.attained_level.titleize}Certificate"]]
    graph << [od_certificate, prefixes[:rdfs].label, "Open Data Certificate for #{certificate.dataset.title}"]
    graph << [od_certificate, prefixes[:dct].published, certificate.created_at.to_date]
    graph << [od_certificate, prefixes[:cert].jurisdiction, prefixes[:jurisdiction][certificate.response_set.jurisdiction.downcase]]
    graph << [od_certificate, prefixes[:cert].badge, RDF::URI.new(badge_dataset_certificate_url(certificate.dataset, certificate, 'png'))]
    graph << [od_certificate, prefixes[:cert].embeddable, RDF::URI.new(badge_dataset_certificate_url(certificate.dataset, certificate, 'js'))]
    
    answers = []
    
    responses.each do |response|
      answer = RDF::Node.new
      graph << [od_certificate, prefixes[:cert].answer, answer]
      question = RDF::URI.new("https://certificates.theodi.org/surveys/questions/#{response.question.id}")
      graph << [answer, RDF.type, prefixes[:cert].Answer]
      graph << [answer, prefixes[:cert].question, question]
      graph << [answer, prefixes[:rdfs].label, ActionView::Base.full_sanitizer.sanitize(response.question.text)]
      if response.answer.input_type == 'url'
        graph << [answer, prefixes[:cert].response, RDF::URI.new(response.statement_text)]
      else
        graph << [answer, prefixes[:cert].response, response.question.text_as_statement + " " + response.statement_text]
      end
    end
    
    return graph
        
  end
  
  def dump_graph(certificate, format, content_type)
    graph = generate_rdf(certificate)
    render :text => graph.dump(format, :prefixes => prefixes), content_type: content_type
  end
  
  def get_responses(certificate)
    responses = []

    certificate.response_set.survey.sections.each do |section|
      qs = section.questions_for_certificate certificate.response_set
      rs = certificate.response_set.responses_for_questions qs
      if rs.any?
        rs.each do |r|
          if r.statement_text != ''
            responses << r
          end
        end
      end
    end
    responses
  end
  
end