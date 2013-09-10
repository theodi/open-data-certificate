require 'fog'

module DataDump
  
  def self.current  
    json = {
      "version" => 0.1,
      "license" => "http://opendatacommons.org/licenses/odbl/",
      "certificates" => {}
    }
          
    certs = Certificate.where(:published => true)
    certs.each do |cert|
      url = view.dataset_certificate_url(cert.dataset, cert)
      json["certificates"][url] = build_item(cert)
    end
       
    upload(json.to_json)
  end
  
  def self.latest  
    dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
    file = dir.files.head "certificates.json"
    
    certs = Certificate.where(:published => true).
              where("updated_at > ?", file.last_modified)
    
    if certs.count > 0
      json = JSON.parse(file.body)
      # Loop through results
      certs.each do |cert|
        # Generate url for certificate
        url = view.dataset_certificate_url(cert.dataset, cert)
        # Replace or add generated json to hash
        json["certificates"][url] = build_item(cert)
      end
      upload(json.to_json)
    end
  end
  
  private

  def self.service
    Fog::Storage.new({
        :provider            => 'Rackspace',
        :rackspace_username  => ENV['RACKSPACE_USERNAME'],
        :rackspace_api_key   => ENV['RACKSPACE_API_KEY'],
        :rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
        :rackspace_region    => :lon
    })
  end

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

  def self.upload(json)
    dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
    dir.files.create :key => "certificates.json", :body => json
  end

end