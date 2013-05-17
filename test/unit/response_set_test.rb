require 'test_helper'

class ResponseSetTest < ActiveSupport::TestCase

  test "creating a response set does not a certificate" do
    assert_no_difference "Certificate.count" do
      FactoryGirl.create :response_set
    end
  end

  test "completing a response set creates a certificate" do
    assert_difference "Certificate.count" do
      FactoryGirl.create :completed_response_set
    end
  end

  test "created certificate is given the attained_level" do
    rs = FactoryGirl.create :completed_response_set
    assert_equal rs.certificate.attained_level, rs.attained_level
  end

end