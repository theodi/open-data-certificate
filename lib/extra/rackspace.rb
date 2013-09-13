require 'fog'

module Rackspace
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

  def self.upload(filename, body)
    dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
    dir.files.create :key => filename, :body => body
  end
  
  def self.fetch_cache(file, expires = 12.hour)
    Rails.cache.fetch(file, :expires_in => expires) do
      Rackspace.dir.files.get(file).body
    end
  end
end