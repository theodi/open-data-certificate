xml.instruct! :xml, :version => "1.0" 
xml.feed :xmlns => "http://www.w3.org/2005/Atom", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.author do |author|
    author.name "Open Data Institute"
  end
  xml.id request.url
  xml.link :href => request.url, :rel => "self"
  xml.link :href => url_for(params.merge(:only_path => false, :page => 1)), :rel => "first"
  xml.link :href => url_for(params.merge(:only_path => false, :page => @datasets.num_pages)), :rel => "last"
  xml.link :href => url_for(params.merge(:only_path => false, :page => @datasets.current_page + 1)), :rel => "next" if @datasets.page(@datasets.current_page + 1).length > 0
  xml.link :href => url_for(params.merge(:only_path => false, :page => @datasets.current_page - 1)), :rel => "prev" if (@datasets.current_page - 1) >= 1
  xml.title @title
  xml.updated DateTime.now.rfc3339.to_s
  @datasets.each do |dataset|
    xml.entry do 
      xml.title dataset.title
      xml.link :href => dataset_url(dataset)
      xml.content dataset.certificate.attained_level_title
      xml.updated DateTime.parse(dataset.updated_at.to_s).rfc3339
      xml.id dataset_url(dataset)
    end
  end
end