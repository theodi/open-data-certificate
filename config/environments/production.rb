OpenDataCertificate::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.cache_store = :memory_store

  config.lograge.enabled = true
  config.lograge.log_format = :logstash
  config.lograge.ignore_actions = %w[main#ping]

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # **IMPORTANT** Define the default url (for devise)

  # config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.default_url_options = {
    :host => ENV["CERTIFICATE_HOSTNAME"]
  }

  config.action_mailer.smtp_settings = {
      :address   => ENV['CERTS_SMTP_ADDRESS'],
      :port      => ENV['CERTS_SMTP_PORT'], # ports 587 and 2525 are also supported with STARTTLS
      :user_name => ENV['CERTS_SMTP_USERNAME'],
      :password  => ENV['CERTS_SMTP_PASSWORD'], # SMTP password is any valid API key
      :authentication => 'login', # Mandrill supports 'plain' or 'login'
      :enable_starttls_auto => true, # detects and uses STARTTLS
      # :domain => 'heroku.com', # your domain to identify your server when connecting
  }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

end
