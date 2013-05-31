if ENV['AIRBRAKE_DIRECTORY_KEY']
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_DIRECTORY_KEY']
  end
end