class ODIBot
  include HTTParty

  USER_AGENT = "ODICertBot 1.0 (+https://certificates.theodi.org/)"

  def initialize(url)
    @options = { headers: {"User-Agent" => USER_AGENT } }
    @url = url
  end

  def response_code
    code = Rails.cache.fetch(@url) rescue nil
    if code.nil?
      code = self.class.get(@url, @options).code
      Rails.cache.write(@url, code, expires_in: 5.minute)
    end
    code
  end
end
