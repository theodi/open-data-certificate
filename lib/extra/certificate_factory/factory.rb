module CertificateFactory

  class Factory
    include HTTParty
    include Sidekiq::Worker

    format :xml

    attr_reader :count, :response

    def initialize(options)
      options.symbolize_keys!
      @url = options[:feed]
      @user_id = options[:user_id]
      @limit = options[:limit].nil? ? nil : options[:limit].to_i
      @campaign = options[:campaign]
      @count = 0
      @response = self.class.get(@url)
      @logger = options[:logger]
      @jurisdiction = options[:jurisdiction]
    end

    def build
      each do |item|
        url = get_link(item)
        CertificateFactory::Certificate.new(url, @user_id, campaign: @campaign, jurisdiction: @jurisdiction).generate
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

    def over_limit?
      @limit && @limit <= @count
    end

    def feed_items
      [response["feed"]["entry"]].flatten # In case there is only one feed item
    end

    def next_page
      response["feed"]["link"].find { |l| l["rel"] == "next" }["href"] rescue nil
    end

    def fetch_next_page
      @url = next_page
      if @url
        @logger.debug "feed: #{@url}" if @logger
        @response = self.class.get(@url)
      else
        return false
      end
    end

    def get_link(item)
      api_url = item["link"].find { |l| l["rel"] == "enclosure" }["href"]
      ckan_url(api_url)
    end

    def ckan_url(api_url)
      CertificateFactory::API.new(api_url).ckan_url
    end
  end

  class CSVFactory < Factory

    def initialize(options)
      options.symbolize_keys!
      @file = options[:file]
      @limit = options[:limit]
      @campaign = options[:campaign]
      @count = 0
      @logger = options[:logger]
      @user_id = options[:user_id]
      @jurisdiction = options[:jurisdiction]
    end

    def get_link(url)
      return url
    end

    def each
      CSV::foreach(@file, headers: :first_row) do |row|
        yield row['documentation_url']
        @count += 1
        break if over_limit?
      end
    end
  end
end
