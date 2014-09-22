require 'test_helper'
require 'odibot'

class ODIBotTest < ActiveSupport::TestCase

  teardown do
    Rails.cache.clear
  end

  test "Should return correct response code for 200" do
    stub_request(:get, "http://www.example.com").
                to_return(:body => "", status: 200)

    bot = ODIBot.new("http://www.example.com")

    assert_equal bot.response_code, 200
  end

  test "Should return correct response code for 500" do
    stub_request(:get, "http://www.example.com").
                to_return(:body => "", status: 500)

    bot = ODIBot.new("http://www.example.com")

    assert_equal bot.response_code, 500
  end

  test "Should cache responses" do
    stub_request(:get, "http://www.example.com").
                to_return(:body => "", status: 200)

    ODIBot.new("http://www.example.com").response_code

    assert_equal 200, Rails.cache.fetch("http://www.example.com")
  end

  test "Should read from the cache if cache value is present" do
    Rails.cache.write("http://www.example.com", 200)

    bot = ODIBot.new("http://www.example.com")

    ODIBot.expects(:get).never

    assert_equal 200, bot.response_code
  end

end
