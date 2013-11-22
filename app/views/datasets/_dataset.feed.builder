builder.id dataset_url(dataset)
builder.link :rel => "about", :href => dataset.documentation_url
builder.link :rel => "alternate", :type => "application/json", 
         :href => polymorphic_url([dataset, certificate], :format => :json)
builder.link :rel => "http://schema.theodi.org/certificate#badge", :type => "text/html",
         :href => badge_dataset_certificate_url(dataset.id, certificate.id, :format => :html)
builder.link :rel => "http://schema.theodi.org/certificate#badge", :type => "application/javascript",
         :href => badge_dataset_certificate_url(dataset.id, certificate.id, :format => :js)