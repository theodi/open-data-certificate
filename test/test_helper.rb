require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'factory_girl'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  
  ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER'] = "certificates_test"

  def assert_attribute_exists(model, attribute)
    assert_respond_to model, attribute
  end

end

require 'mocha/setup'
