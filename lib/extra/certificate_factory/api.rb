module CertificateFactory
  class API
    include HTTParty

    format :json

    def initialize(url)
      @url = url
      @response = self.class.get(@url)
    end

    def ckan_url
      @response['ckan_url']
    end
  end
end
