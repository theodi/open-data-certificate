if ENV['COVERAGE']
  require 'coveralls'
  Coveralls.wear_merged! 'rails'
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'json_spec'
require 'database_cleaner'

# for asset_pipeline_enabled? in models
include Surveyor::Helpers::AssetPipeline

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Changing this here is pretty stupid. I'm doing it because we have it set
# to :logging for the rest of the app, but I don't want to remove all the tests
# around this in Surveyor. Best steps forward would be to set this to :strict
# everywhere and fix any code that breaks.
ActiveRecord::Base.mass_assignment_sanitizer = :strict

RSpec.configure do |config|
  config.include JsonSpec::Helpers
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.mock_with :rspec

  ## Database Cleaner

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each, :clean_with_truncation) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each, :clean_with_truncation) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
