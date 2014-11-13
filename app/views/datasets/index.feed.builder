xml.instruct! :xml, :version => "1.0" 
xml.feed :xmlns => "http://www.w3.org/2005/Atom", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.author do |author|
    author.name "Open Data Institute"
  end
  xml.id "#{embed_protocol}#{request.host_with_port}#{request.path}?#{request.query_string}"
  xml.link :href => "#{embed_protocol}#{request.host_with_port}#{request.path}?#{request.query_string}", :rel => "self"
  xml.link :href => url_for(params.merge(:only_path => false, :page => 1, :protocol => embed_protocol)), :rel => "first"
  xml.link :href => url_for(params.merge(:only_path => false, :page => @datasets.num_pages, :protocol => embed_protocol)), :rel => "last"
  xml.link :href => url_for(params.merge(:only_path => false, :page => @datasets.current_page + 1, :protocol => embed_protocol)), :rel => "next" if @datasets.page(@datasets.current_page + 1).length > 0
  xml.link :href => url_for(params.merge(:only_path => false, :page => @datasets.current_page - 1, :protocol => embed_protocol)), :rel => "prev" if (@datasets.current_page - 1) >= 1
  xml.title @title
  xml.updated atom_datetime(@last_modified_date)
  @datasets.each do |dataset|
    xml.entry do
      xml.title dataset.title
      xml.content dataset.certificate.attained_level_title
      xml.updated atom_datetime(dataset.modified_date)
      render(:partial => 'datasets/dataset', 
             :locals => {:builder => xml, :dataset => dataset, :certificate => dataset.certificates.latest })
    end
  end
end
