if ENV['AIRBRAKE_CERTIFICATE_KEY']
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_CERTIFICATE_KEY']

    # displayed in the 500.html error page
    config.user_information = "Exception ID <strong>{{ error_id }}</strong>"
  end
end