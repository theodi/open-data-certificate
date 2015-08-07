require 'test_helper'
require 'flow'

class FlowchartsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "it sets defaults correctly" do
    get 'show'

    assert assigns(:jurisdiction) == "gb"
    assert assigns(:type) == "Practical"

  end

  # these tests should test that each of the methods of the controller are functioning as expected,
  # as most significant stuff done in the cucumber tests
  test "it sets the correct questions and dependencies for provided questionairre" do
    get 'show'

    flow = Flow.new("gb", "Practical")
    # below tests presume that the Flow gem is already capturing all the questions it should from the questionairre
    assert assigns(:questions).count == flow.questions.count
    assert assigns(:dependencies).count == flow.dependencies.count
    # because assert assigns creates an array of HashWithIndifferentAccess and flow creates arrays of Hashes an equality test of contents will return false
    # a comparison for each would be more rigorous for instance: assigns(:questions).first.each_with_index do |elements, index| assert elements == flow.questions[index] end;

  end

  test "there should be four levels from provided questionairre" do
    # the questionairre should have four levels (raw, pilot, standard, exemplar)
    get 'show'
    assert assigns(:levels).count == 4
  end

  test "constituents of @levels hash corresponds to sum of elements in dependencies and questions arrays" do

    get 'show'

    flow = Flow.new("gb", "Practical")
    levelCount = 0
    assigns(:levels).values.each do |innerArray|
      levelCount += innerArray.count
    end
    assert levelCount == flow.questions.count + flow.dependencies.count

  end

end