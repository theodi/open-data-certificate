require 'rackspace'

module CertificateDump
  FILENAME = "certificates.json"  
  
  def self.perform
    file = Rackspace.dir.files.head FILENAME
    if file.nil?
      current
    else
      latest
    end
    
    Delayed::Job.enqueue CertificateDump, { :priority => 5, :run_at => 1.day.from_now }
  end
  
  def self.current
    json = {
      "version" => 0.1,
      "license" => "http://opendatacommons.org/licenses/odbl/",
      "certificates" => {}
    }
          
    certs = Certificate.where(:published => true)
    certs.each do |cert|
      append_json(json, cert)
    end
       
    Rackspace.upload(FILENAME, json.to_json)
  end
  
  def self.latest
    file = Rackspace.dir.files.head FILENAME
    
    certs = Certificate.where(:published => true).
              where("updated_at > ?", file.last_modified)
    
    if certs.count > 0
      json = JSON.parse(file.body)
      # Loop through results
      certs.each do |cert|
        append_json(json, cert)
      end
      Rackspace.upload(FILENAME, json.to_json)
    end
  end
  
  private
  
  def self.view
    view = ApplicationController.view_context_class.new
    view.view_paths.unshift("#{Rails.root}/app/views/")

    class << view
        routes = Rails.application.routes
        routes.default_url_options = {:host => 'certificates.theodi.org', :protocol => 'https'}
        include routes.url_helpers
    end
    view
  end

  def self.build_item(cert)
    json = JbuilderTemplate.new(view).tap do |json|
      json.partial! 'certificates/certificate', cert: cert
    end
  end
  
  def self.append_json(json, cert)
    url = view.dataset_certificate_url(cert.dataset, cert)
    json["certificates"][url] = build_item(cert)
  end
end