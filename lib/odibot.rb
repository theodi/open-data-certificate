class ODIBot
  include HTTParty

  USER_AGENT = "ODICertCheck 1.1 (+https://certificates.theodi.org/)"
  NETWORK_ERRORS = [
    EOFError,
    SocketError,
    Errno::ETIMEDOUT,
    Errno::ECONNREFUSED,
    Errno::ECONNRESET,
    Errno::EHOSTUNREACH,
    OpenSSL::SSL::SSLError,
    Timeout::Error,
    Net::ReadTimeout
  ]
  HTTP_ERRORS = [
    HTTParty::RedirectionTooDeep,
    URI::InvalidURIError,
    Zlib::DataError
  ]

  def self.valid?(url)
    new(url).valid?
  end

  def initialize(url)
    @options = { headers: {"User-Agent" => USER_AGENT } }
    @url = url
  end

  def response_code
    self.class.handle_errors(0) do
      url = uri.to_s
      Rails.cache.fetch(url, expires_in: 5.minutes) do
        code = self.class.head(url, @options).code
        code = self.class.get(url, @options).code if code == 404
        code
      end
    end
  end

  def is_http_url?
    if uri.kind_of?(URI::HTTP)
      hostname = uri.hostname
      hostname.present? && hostname.include?('.')
    else
      false
    end
  end

  def uri
    begin
      @uri ||= URI.parse(@url)
    rescue URI::InvalidURIError
      @uri ||= URI.parse(escape_unsafe_chars(@url))
    end
  rescue URI::InvalidURIError
    nil
  end

  def linkedin?
    (uri.hostname =~ /linkedin\.com/).present?
  end

  def valid?
    is_http_url? && (linkedin? || response_code == 200)
  end

  def check_ckan_endpoint
    success = false
    redirect = nil
    if valid?
      begin
        url = URI.parse(@url)
        r = Net::HTTP.get_response(url)
        if r.code.eql?("301")
          redirect = r.header['location']
          r = Net::HTTP.get_response(URI.parse(r.header['location']))
        end
        success = JSON.parse(r.body).has_key?("version") if r.code.eql?("200")
      rescue
        success = false
      end
    end
    { success: success, redirect: redirect }
  end

  def self.handle_errors(return_value)
    return yield
  rescue *(NETWORK_ERRORS + HTTP_ERRORS)
    return return_value
  end

private
  def escape_unsafe_chars(url)
    url.gsub(URI::UNSAFE) { |c| URI.escape(c) }
  end

end
