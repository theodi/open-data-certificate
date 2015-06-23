require 'rubygems'
require 'spork'

Spork.prefork do
  require 'coveralls'

  Coveralls.wear_merged! 'rails'

  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

  require 'factory_girl'
  require 'vcr'
  require 'mocha/setup'
  require 'webmock/test_unit'
  require 'sidekiq/testing'

  Sidekiq::Testing.inline!
end

Spork.each_run do
  # ENVARS that need to be presnet in the env before being escaped by VCR
  ENV['GAPPS_USER_EMAIL'] = "GAPPS_USER_EMAIL"
  ENV['GAPPS_PASSWORD'] = "GAPPS_PASSWORD"

  VCR.configure do |c|
    # Automatically filter all secure details that are stored in the environment
    ignore_env = %w{SHLVL RUNLEVEL GUARD_NOTIFY DRB COLUMNS USER LOGNAME LINES TERM_PROGRAM_VERSION}
    (ENV.keys-ignore_env).select{|x| x =~ /\A[A-Z_]*\Z/}.each do |key|
      c.filter_sensitive_data("<#{key}>") { ENV[key] }
    end
    c.cassette_library_dir = 'fixtures/cassettes'
    c.default_cassette_options = { :record => :once }
    c.hook_into :webmock
    c.ignore_hosts 'licenses.opendefinition.org', 'www.example.com'
  end

  class ActiveSupport::TestCase
    # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
    #
    # Note: You'll currently still have to declare fixtures explicitly in integration tests
    # -- they do not yet inherit this setting
    # fixtures :all

    # Configuration ENVARS:
    ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER'] = "certificates_test"
    ENV['GAPPS_CERTIFICATE_USAGE_COLLECTION'] = "ODI Drive/Technical/Test Data/Usage Data"

    # Add more helper methods to be used by all tests here...
    def assert_attribute_exists(model, attribute)
      assert_respond_to model, attribute
    end

    def load_custom_survey fname
      builder = SurveyBuilder.new 'test/fixtures/surveys_custom', fname
      builder.parse_file
    end

    def http_auth(user)
      header = ActionController::HttpAuthentication::Basic.encode_credentials(
        user.email, user.authentication_token)
      request.env['HTTP_AUTHORIZATION'] = header
      sign_in user
    end
  end

end
