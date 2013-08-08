# Load the rails application
require File.expand_path('../application', __FILE__)
Mime::Type.register "text/turtle", :ttl
Mime::Type.register "application/rdf+xml", :rdf

# Initialize the rails application
OpenDataCertificate::Application.initialize!
