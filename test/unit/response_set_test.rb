require 'test_helper'

class ResponseSetTest < ActiveSupport::TestCase

  test "creating a response set does not a certificate" do
    assert_no_difference "Certificate.count" do
      @reponse_set = FactoryGirl.create :response_set
    end
  end

  test "completing a response set creates a certificate" do
    assert_difference "Certificate.count" do
      FactoryGirl.create :completed_response_set
    end
  end

end