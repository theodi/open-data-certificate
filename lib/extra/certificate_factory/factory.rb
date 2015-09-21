module CertificateFactory

  class HTTPFactory
    include HTTParty

    attr_reader :count

    def initialize(options)
      options.symbolize_keys!
      @user_id = options[:user_id]
      @limit = options[:limit].nil? ? nil : options[:limit].to_i
      @campaign = options[:campaign]
      @count = 0
      @logger = options[:logger]
      @jurisdiction = options[:jurisdiction]
      @feed = options[:feed]
    end

    def url
      @feed
    end

    def uri
      URI.parse(@feed)
    end

    def build
      each do |resource|
        url = get_dataset_url(resource)
        certificate = CertificateFactory::Certificate.new(
          url, @user_id, campaign: @campaign, jurisdiction: @jurisdiction)
        certificate.generate
      end
    end

    def each
      loop do
        feed_items.each do |item|
          yield item
          @count += 1
          return if over_limit?
        end
        return unless fetch_next_page
      end
    end

    def response
      @response || fetch_response!
    end

    def fetch_response!(url=url)
      @response = self.class.get(url)
    end

    def over_limit?
      @limit && @limit <= @count
    end

    def fetch_next_page
      url = next_page
      if url
        @logger.debug "feed: #{url}" if @logger
        fetch_response!(url)
      else
        return false
      end
    end

  end

  class AtomFactory < HTTPFactory

    format :xml

    def feed_items
      [response["feed"]["entry"]].flatten # In case there is only one feed item
    end

    def next_page
      response["feed"]["link"].find { |l| l["rel"] == "next" }["href"] rescue nil
    end

    def get_dataset_url(item)
      api_url = item["link"].find { |l| l["rel"] == "enclosure" }["href"]
      CertificateFactory::API.new(api_url).ckan_url
    end

  end

  class CKANFactory < HTTPFactory
    format :json

    def initialize(options)
      super
      @rows = options.fetch(:row_size, 20)
      @start = 0
    end

    def url
      build_url("api/3/action/package_search", 'rows' => @rows)
    end

    def feed_items
      if response['success']
        response['result']['results']
      else
        []
      end
    end

    def count
      if response['success']
        response['result']['count']
      else
        0
      end
    end

    def build_url(path, params={})
      u = uri + path
      qs = CGI.parse(u.query.to_s).merge(params)
      u.query = URI.encode_www_form(qs.merge(params)) if qs.any?
      return u.to_s
    end

    def next_page
      build_url("api/3/action/package_search", 'rows' => @rows, 'start' => @start)
    end

    def fetch_next_page
      @start += feed_items.count
      super if @start < count
    end

    def get_dataset_url(resource)
      build_url("dataset/#{resource['name']}")
    end
  end
end
