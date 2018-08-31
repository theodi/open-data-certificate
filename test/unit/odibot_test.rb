require_relative '../test_helper'
require 'odibot'

class ODIBotTest < ActiveSupport::TestCase

  teardown do
    Rails.cache.clear
  end

  test "Should return correct response code for 200" do
    stub_request(:head, "http://www.example.com").
                to_return(:body => "", status: 200)

    bot = ODIBot.new("http://www.example.com")

    assert_equal bot.response_code, 200
  end

  test "Should return correct response code for 500" do
    stub_request(:head, "http://www.example.com").
                to_return(:body => "", status: 500)

    bot = ODIBot.new("http://www.example.com")

    assert_equal bot.response_code, 500
  end

  test "Should cache responses" do
    stub_request(:head, "http://www.example.com").
                to_return(:body => "", status: 200)

    ODIBot.new("http://www.example.com").response_code

    assert_equal 200, Rails.cache.fetch("http://www.example.com")
  end

  test "Should read from the cache if cache value is present" do
    Rails.cache.write("http://www.example.com", 200)

    bot = ODIBot.new("http://www.example.com")

    ODIBot.expects(:head).never

    assert_equal 200, bot.response_code
  end

  test "http url is valid" do
    bot = ODIBot.new("http://example.org")
    assert bot.is_http_url?
  end

  test "https url is valid" do
    bot = ODIBot.new("https://example.org")
    assert bot.is_http_url?
  end

  test "adapts unsafe characters to escaped equivlent" do
    bot = ODIBot.new("http://example.org/dataset/dataset .csv")
    assert_equal URI.parse("http://example.org/dataset/dataset%20.csv"), bot.uri
  end

  test "exception raising uri is invalid" do
    bot = ODIBot.new("!:!:")
    refute bot.is_http_url?
  end

  test "generic uri is invalid" do
    bot = ODIBot.new("foo bar")
    refute bot.is_http_url?
  end

  test "validates url by checking if http response is ok" do
    stub_request(:head, "http://www.example.com").
                to_return(:body => "", status: 200)
    assert ODIBot.new("http://www.example.com").valid?
  end

  test "validates url by checking if get response if head is not found" do
    # CKAN API behaves badly and 404s HEAD requests when GET returns a response
    stub_request(:head, "http://www.example.com").
                to_return(:body => "", status: 404)
    stub_request(:get, "http://www.example.com").
                to_return(:body => "", status: 200)
    assert ODIBot.new("http://www.example.com").valid?
  end

  test "checks if url is http before fetching" do
    ODIBot.expects(:head).never
    refute ODIBot.new("foo bar").valid?
  end

  test "checks if url is specified enough to request" do
    ODIBot.expects(:head).never
    refute ODIBot.new("http://").valid?
    refute ODIBot.new("http:///").valid?
    refute ODIBot.new("http://notadomain").valid?
  end

  %w[http https].each do |scheme|
    %w[www.linkedin.com linkedin.com].each do |hostname|
      %w[/ page/subpage].each do |path|
        url = "#{scheme}://#{hostname}#{path}"
        test "skips http checks if url is #{url}" do
          ODIBot.expects(:head).never
          assert ODIBot.new(url).valid?
        end
      end
    end
  end

  [SocketError, Errno::ETIMEDOUT, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH, OpenSSL::SSL::SSLError, Timeout::Error, EOFError].each do |error|
    test "handles #{error.name}" do
      stub_request(:head, "http://www.example.com").to_raise(error)
      refute ODIBot.new("http://www.example.com").valid?
    end
  end

  test "handles too many redirects error" do
    redirect = "http://www.example.org/circle"
    stub_request(:head, redirect).to_return(:status => 404)
    stub_request(:get, redirect).to_return(
      :status => 302, :headers => { 'Location' => redirect }
    )
    refute ODIBot.new(redirect).valid?
  end

  test "gives up on invalid URIs from a redirect" do
    ODIBot.stubs(:head).raises(URI::InvalidURIError)
    refute ODIBot.new("http://any.domain").valid?
  end

  test "successfully checks CKAN API" do
    stub_request(:any, "http://www.example.com/api").to_return(:body => { version: "1" }.to_json, status: 200)
    bot = ODIBot.new("http://www.example.com/api")
    result = bot.check_ckan_endpoint
    assert_equal true, result[:success]
  end

  test "successfully handles wrong CKAN endpoint" do
    stub_request(:any, "http://www.example.com/")
      .to_return(:body => "<html>Uhoh, a totally normal html websait</html>", status: 200)
    bot = ODIBot.new("http://www.example.com/")
    result = bot.check_ckan_endpoint
    assert_equal false, result[:success]
  end

  test "successfully checks valid CKAN API which returns a valid status" do
    stub_request(:any, "http://www.example.com/api").to_return(status: 404)
    stub_request(:any, "http://www.example.com/api/util/status").to_return(:body => {ckan_version: "2.8"}.to_json, status: 200)
    bot = ODIBot.new("http://www.example.com/api")
    result = bot.check_ckan_endpoint
    assert_equal true, result[:success]
  end

end
