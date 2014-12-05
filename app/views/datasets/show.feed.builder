xml.instruct! :xml, :version => "1.0"
xml.feed :xmlns => "http://www.w3.org/2005/Atom", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.author  do
    xml.name @dataset.user_name
  end
  xml.updated atom_datetime(@dataset.modified_date)
  xml.id dataset_url(@dataset, format: :feed, :protocol => embed_protocol)
  xml.title @dataset.title
  xml.link :href=> @dataset.documentation_url, :rel => "self", :protocol => embed_protocol
  @dataset.certificates.where(published: true).by_newest.each do |certificate|
    xml.entry do
      xml.link :href=> dataset_latest_certificate_url(@dataset, :protocol => embed_protocol)
      xml.title certificate.name
      xml.content certificate.attained_level_title
      xml.updated atom_datetime(certificate.updated_at)
      render(:partial => 'datasets/dataset',
             :locals => {:builder => xml, :dataset => @dataset, :certificate => certificate })
    end
  end
end
