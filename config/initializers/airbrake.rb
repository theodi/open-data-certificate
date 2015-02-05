if ENV['AIRBRAKE_CERTIFICATE_KEY']
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_CERTIFICATE_KEY']
    config.environment_name = OpenDataCertificate.staging? ? "staging" : Rails.env

    # displayed in the 500.html error page
    config.user_information = "Exception ID <strong>{{ error_id }}</strong>"
  end

  require 'delayed-plugins-airbrake'
  Delayed::Worker.plugins << Delayed::Plugins::Airbrake::Plugin
end
