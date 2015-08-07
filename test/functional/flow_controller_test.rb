require 'test_helper'
require 'flow'

class FlowchartsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "it sets defaults" do
    get 'show'

    assert assigns(:jurisdiction) == "gb"
    assert assigns(:type) == "Practical"
  end

end
