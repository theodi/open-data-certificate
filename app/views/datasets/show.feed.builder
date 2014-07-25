xml.instruct! :xml, :version => "1.0"
xml.feed :xmlns => "http://www.w3.org/2005/Atom", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.author  do
    xml.name @dataset.user_full_name
  end
  xml.updated DateTime.parse(@dataset.updated_at.to_s).rfc3339
  xml.id dataset_url(@dataset, format: :feed, :protocol => embed_protocol)
  xml.title @dataset.title
  xml.link :href=> @dataset.documentation_url, :rel => "self", :protocol => embed_protocol
  @dataset.certificates.where(published: true).by_newest.each do |certificate|
    xml.entry do
      xml.link :href=> dataset_certificate_url(@dataset, certificate, :protocol => embed_protocol)
      xml.title certificate.name
      xml.content certificate.attained_level_title
      xml.updated DateTime.parse(certificate.updated_at.to_s).rfc3339
      render(:partial => 'datasets/dataset',
             :locals => {:builder => xml, :dataset => @dataset, :certificate => certificate })
    end
  end
end
