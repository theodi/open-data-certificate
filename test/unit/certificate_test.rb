require 'test_helper'

class CertificateTest < ActiveSupport::TestCase

  def setup
    @certificate = FactoryGirl.create :certificate
    @response_set = @certificate.response_set
  end

  test "certificate gets attained level from linked response_set" do
    assert_equal @certificate.attained_level, @response_set.attained_level
  end

end
