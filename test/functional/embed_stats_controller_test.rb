require 'test_helper'

class EmbedStatsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should generate a CSV of all embeds" do
    dataset = FactoryGirl.create :dataset
    dataset.register_embed("http://example.com")

    get 'index'

    assert_response :success
    assert_equal response.headers["Content-Type"], 'text/csv; header=present; charset=utf-8'

    csv = CSV.parse(response.body)

    assert_equal csv.count, 2
  end

end
