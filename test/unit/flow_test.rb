require 'test_helper'

class Flow < ActiveSupport::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    flow = Flow.new("gb", "Practical")
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  test 'it has initialised' do
    assert_not_empty(flow)
  end

  # Fake test
  # def test_fail
  #   fail('Not implemented')
  # end

  def teardown
    # Do nothing
  end


end