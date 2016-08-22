module CertificateFactory

  class HTTPFactory
    include Enumerable
    include HTTParty

    attr_reader :count

    def initialize(options)
      options.symbolize_keys!
      # starting options
      if options.fetch(:is_prefetch, false)
        @campaign = options[:campaign]
      else
        @campaign = CertificationCampaign.find(options[:campaign_id])
      end
      @user_id = @campaign.user
      @jurisdiction = @campaign.jurisdiction
      @feed = @campaign.url

      # continuation options
      @count = options.fetch(:count, 0).to_i
      @limit = options[:limit].nil? ? nil : options[:limit].to_i
      @include_harvested = options.fetch(:include_harvested, false)
      @skipped = 0
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
        if url.blank?
          @skipped+=1
          next
        end
        certificate = CertificateFactory::Certificate.new(
          url, @user_id, campaign: @campaign, jurisdiction: @jurisdiction)
        certificate.generate
      end
    end

    def prebuild
      generators = []
      feed_items.each do |item|
        url = get_dataset_url(item)
        if url.blank?
          @skipped+=1
        else
          generator = CertificateGenerator.create(request: { documentationUrl: url }, user: @user_id)
          generator.certification_campaign = @campaign
          generator.generate(@jurisdiction, @user_id)
          generator.certificate.update_attributes(published_at: nil, aasm_state: nil, published: false)
          generators << generator
        end
        @count += 1
        return generators if over_limit?
      end
      return generators
    end

    def each
      feed_items.each do |item|
        yield item
        @count += 1
        return if over_limit?
      end
      fetch_next!
    end

    def response
      @response || fetch_response!
    end

    def fetch_response!
      @response = self.class.get(url)
    end

    def over_limit?
      @limit && @limit <= @count
    end

    def next_options
      { campaign_id: @campaign.id, factory: self.class.name, count: @count, include_harvested: @include_harvested }
    end

    def fetch_next!
      if fetch_next?
        CertificateFactory::FactoryRunner.perform_async(next_options)
      end
    end

    def factory_name
      self.class.name.split('::').last
    end

    def skipped
      @skipped
    end

  end

  class AtomFactory < HTTPFactory
    format :xml

    def initialize(options)
      super
      @feed = options.fetch(:feed, @feed)
    end

    def feed_items
      [response["feed"]["entry"]].flatten # In case there is only one feed item
    end

    def next_options
      super.merge(feed: next_page)
    end

    def fetch_next?
      next_page.present?
    end

    def next_page
      rel_next = response["feed"]["link"].find { |l| l["rel"] == "next" }
      rel_next['href'] if rel_next
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
      @rows = options.fetch(:rows, 20)
      @params = options.fetch(:params, {})
      filter_strings = @campaign.subset.collect { |k,v| next if v.blank?; "+#{k}:#{v}" }.join()
      @params.merge!({fq: filter_strings}) unless filter_strings.blank?
    end

    def url
      build_url("/api/3/action/package_search", 'rows' => @rows, 'start' => @count)
    end

    def feed_items
      if response['success']
        response['result']['results']
      else
        []
      end
    end

    def result_count
      if response['success']
        response['result']['count']
      else
        0
      end
    end

    def dataset_count
      dataset_count = result_count
      dataset_count = @limit if !@limit.blank? and (@limit < dataset_count)
      return (dataset_count - @skipped)
    end

    def save_dataset_count
      @campaign.update_attribute(:dataset_count, dataset_count) if @campaign
    end

    def build
      super
      save_dataset_count
    end

    def build_url(path, params={})
      path = uri.path.gsub("/api", path) unless uri.path.eql?("/")
      u = URI::join(uri.to_s, path)
      qs = CGI.parse(u.query.to_s).merge(@params).merge(params)
      u.query = URI.encode_www_form(qs.merge(params)) if qs.any?
      return u.to_s
    end

    def next_options
      super.merge(count: @count, rows: @rows, params: @params)
    end

    def fetch_next?
      @count < result_count
    end

    def get_dataset_url(resource)
      if resource['harvest_source_title'].blank?
        return build_url("/dataset/#{resource['name']}")
      else
        if @include_harvested
          return resource['extras'].each {|e| break e["value"] if e["key"].eql?("harvest_url")  }
        else
          return nil
        end
      end
    end

  end
end
