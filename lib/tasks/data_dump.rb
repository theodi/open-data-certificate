require 'fog'
require 'csv'

module DataDump
  
  def self.current_certificates
    json = {
      "version" => 0.1,
      "license" => "http://opendatacommons.org/licenses/odbl/",
      "certificates" => {}
    }
          
    certs = Certificate.where(:published => true)
    certs.each do |cert|
      append_json(json, cert)
    end
       
    upload("certificates.json", json.to_json)
  end
  
  def self.latest_certificates
    file = dir.files.head "certificates.json"
    
    certs = Certificate.where(:published => true).
              where("updated_at > ?", file.last_modified)
    
    if certs.count > 0
      json = JSON.parse(file.body)
      # Loop through results
      certs.each do |cert|
        append_json(json, cert)
      end
      upload("certificates.json", json.to_json)
    end
  end
  
  def self.current_stats
    csv = CSV.generate do |csv|
      csv << [
          "Date",
          "All surveys started",
          "All Certificates", 
          "All Datasets", 
          "Published Certificates", 
          "Published Datasets",
          "Raw level Certificates",
          "Pilot level Certificates",
          "Standard level Certificates",
          "Expert level Certificates",
        ]
      csv << [
          Date.today.to_s, 
          Certificate.counts[:all], 
          ResponseSet.counts[:all],
          ResponseSet.counts[:all_datasets], 
          Certificate.counts[:published], 
          ResponseSet.counts[:published_datasets],
          Certificate.counts[:levels][:basic],
          Certificate.counts[:levels][:pilot],
          Certificate.counts[:levels][:standard],
          Certificate.counts[:levels][:expert],
        ]
    end
    
    upload("statistics.csv", csv)
  end
  
  def self.latest_stats
    file = dir.files.head "statistics.csv"
    csv = CSV.parse(file.body)
    csv << [
          Date.today.to_s, 
          Certificate.counts[:all], 
          ResponseSet.counts[:all_datasets], 
          Certificate.counts[:published], 
          ResponseSet.counts[:published_datasets],
          Certificate.counts[:levels][:basic],
          Certificate.counts[:levels][:pilot],
          Certificate.counts[:levels][:standard],
          Certificate.counts[:levels][:expert],
        ]
    
    body = CSV.generate do |body|
      csv.each { |row| body << row }
    end
    
    upload("statistics.csv", body)
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
  
  def self.dir
    service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
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
  
  def self.append_json(json, cert)
    url = view.dataset_certificate_url(cert.dataset, cert)
    json["certificates"][url] = build_item(cert)
  end

  def self.upload(filename, body)
    dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
    dir.files.create :key => filename, :body => body
  end

end