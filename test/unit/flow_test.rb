require 'test_helper'

class FlowTest < ActiveSupport::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @flow = Flow.new("gb", "Practical")
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  #test 'it has initialised' do
  #  assert_not_empty(@flow)
  #end

  # Fake test
  # def test_fail
  #   fail('Not implemented')
  # end

  #No of questions

  test 'count questions' do
    assert_equal @flow.questions.count, 7
  end

  test 'count dependencies' do
    assert_equal @flow.dependencies.count, 3
  end

  def teardown
    # Do nothing
  end


end
