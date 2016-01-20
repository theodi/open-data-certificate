require_relative '../test_helper'

class ApplicationControllerTest < ActionController::TestCase

  test "parse iso8601 year only" do
    ac = ApplicationController.new
    assert_equal DateTime.new(2014, 1, 1), ac.send(:parse_iso8601, "2014")
    assert_equal DateTime.new(1999, 1, 1), ac.send(:parse_iso8601, "1999")
  end

  test "parse iso8601 year and month" do
    ac = ApplicationController.new
    assert_equal DateTime.new(2014, 5, 1), ac.send(:parse_iso8601, "2014-05")
  end

  test "parse iso8601 date string" do
    ac = ApplicationController.new
    assert_equal DateTime.new(2014, 5, 17), ac.send(:parse_iso8601, "2014-05-17")
    assert_equal DateTime.new(2014, 5, 17, 16, 40), ac.send(:parse_iso8601, "2014-05-17T16:40")
    assert_equal DateTime.new(2014, 5, 17, 16, 40, 05), ac.send(:parse_iso8601, "2014-05-17T16:40:05")
  end

end
