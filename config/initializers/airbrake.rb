if ENV['AIRBRAKE_CERTIFICATE_KEY']
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_CERTIFICATE_KEY']
  end
end