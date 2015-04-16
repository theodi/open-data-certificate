class ODIBot
  include HTTParty

  USER_AGENT = "ODICertBot 1.0 (+https://certificates.theodi.org/)"

  def initialize(url)
    @options = { headers: {"User-Agent" => USER_AGENT } }
    @url = url
  end

  def response_code
    ODIBot.handle_errors(0) do
      code = Rails.cache.fetch(@url) rescue nil
      if code.nil?
        code = self.class.get(@url, @options).code
        Rails.cache.write(@url, code, expires_in: 5.minute)
      end
      code
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
    @uri ||= URI.parse(@url)
  rescue URI::InvalidURIError
    nil
  end

  def valid?
    is_http_url? && response_code == 200
  end

  def self.handle_errors(return_value)
    return yield
  rescue SocketError, Errno::ETIMEDOUT, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH, OpenSSL::SSL::SSLError, Timeout::Error
    return return_value
  end
end
