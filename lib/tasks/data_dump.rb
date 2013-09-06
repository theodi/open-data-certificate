require 'fog'

def service
  Fog::Storage.new({
      :provider            => 'Rackspace',
      :rackspace_username  => ENV['RACKSPACE_USERNAME'],
      :rackspace_api_key   => ENV['RACKSPACE_API_KEY'],
      :rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
      :rackspace_region    => :lon
  })
end

def av
  av = ActionView::Base.new
  av.view_paths = ActionController::Base.view_paths

  class << av
      routes = Rails.application.routes
      routes.default_url_options = {:host => 'certificates.theodi.org', :protocol => 'https'}
      include routes.url_helpers
  end
  av
end

def build_item(certificate)
  json = "\"#{av.dataset_certificate_url(certificate.dataset, certificate)}\":"
  json << av.render(
      :file => 'certificates/_certificate.json', 
      :layout => nil, 
      :locals => { :cert => certificate }
      )
end

def upload(json)
  dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
  dir.files.create :key => "certificates.json", :body => json
end