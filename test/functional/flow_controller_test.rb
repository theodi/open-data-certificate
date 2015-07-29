require 'test_helper'

class FlowchartsControllerTest < ActionController::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  # def setup
  #   # Do nothing
  # end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  test "it initialises" do
    theflo = FlowchartsController.new
    assert_not_empty(theflo)
  end

  # def teardown
  #   # Do nothing
  # end

  # Fake test
  # def test_fail
  #
  #   fail('Not implemented')
  # end
end