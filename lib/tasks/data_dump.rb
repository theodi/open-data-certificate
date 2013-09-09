require 'fog'

module DataDump
  
  def self.current
    a = []
    
    json = '{"version": 0.1,"license": "http://opendatacommons.org/licenses/odbl/","certificates": {'
      
    certs = Certificate.where(:published => true)
    certs.each do |cert|
      a << build_item(cert)
    end
    
    json << a.join(',')
    json << "}}"
       
    upload(json)
  end
  
  def self.latest
    new = 0
    updated = 0
    
    dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
    file = dir.files.head "certificates.json"
    
    certs = Certificate.where(:published => true).
              where("updated_at > ?", file.last_modified)
    
    if certs.count > 0
      json = JSON.parse(dir.files.get("certificates.json").body)
      # Loop through results
      certs.each do |cert|
        url = av.dataset_certificate_url(cert.dataset, cert)
        if json[url].nil?
          # If certificate doesn't exist, add it
          json << JSON.parse("{"+ build_item(cert) +"}")
          new += 1
        else
          # If not, update what's already there
          json[url] = JSON.parse("{"+ build_item(cert) +"}")
          updated += 1
        end
      end
      upload(json.to_s)
      puts "#{new} certificates added"
      puts "#{updated} certificates updated"
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

  def self.av
    av = ActionView::Base.new
    av.view_paths = ActionController::Base.view_paths

    class << av
        routes = Rails.application.routes
        routes.default_url_options = {:host => 'certificates.theodi.org', :protocol => 'https'}
        include routes.url_helpers
    end
    av
  end

  def self.build_item(certificate)
    json = "\"#{av.dataset_certificate_url(certificate.dataset, certificate)}\":"
    json << av.render(
        :file => 'certificates/_certificate',
        :formats => [:json],
        :layout => nil, 
        :locals => { :cert => certificate }
        )
  end

  def self.upload(json)
    dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
    dir.files.create :key => "certificates.json", :body => json
  end

end