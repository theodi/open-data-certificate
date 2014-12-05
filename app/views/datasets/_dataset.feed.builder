builder.id dataset_url(dataset, :protocol => embed_protocol)
builder.link :href=> dataset_url(dataset, :protocol => embed_protocol)
builder.link :rel => "http://schema.theodi.org/certificate#certificate", :type => "text/html",
         :href => dataset_latest_certificate_url(dataset.id, :protocol => embed_protocol)
builder.link :rel => "about", :href => dataset.documentation_url
builder.link :rel => "alternate", :type => "application/json",
         :href => dataset_latest_certificate_url(dataset.id, :format => :json, :protocol => embed_protocol)
builder.link :rel => "http://schema.theodi.org/certificate#badge", :type => "text/html",
         :href => badge_dataset_latest_certificate_url(dataset.id, :format => :html, :protocol => embed_protocol)
builder.link :rel => "http://schema.theodi.org/certificate#badge", :type => "application/javascript",
         :href => badge_dataset_latest_certificate_url(dataset.id, :format => :js, :protocol => embed_protocol)
