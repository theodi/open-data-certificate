require 'test_helper'

class EmbedStatTest < ActiveSupport::TestCase

  test "should create an embed stat with a valid URL" do
    e = EmbedStat.create(referer: "http://example.com/page")

    assert e.valid?
    assert_equal EmbedStat.all.count, 1
  end

  test "should give an error if the URL is invalid" do
    e = EmbedStat.create(referer: "this is not a URL")

    refute e.valid?
    assert_equal e.errors.first, [:referer, "is not a valid URL"]
  end

end
