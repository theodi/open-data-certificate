OpenDataCertificate::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  
  if ENV["MEMCACHED_HOSTS"]
    config.cache_store = :mem_cache_store, ENV["MEMCACHED_HOSTS"]
  else
    config.cache_store = :memory_store
  end
  
  config.lograge.enabled = true
  config.lograge.log_format = :logstash

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

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( badge.css )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # **IMPORTANT** Define the default url (for devise)

  # config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # For testing on heroku we're using the mandril addon on odc-stage.herokuapp.com
  #   - https://addons.heroku.com/mandrill
  if ENV["MANDRILL_USERNAME"]

    # **IMPORTANT** Define the default url (for devise)
    config.action_mailer.default_url_options = { :host => 'certificates.theodi.org' }

    config.action_mailer.smtp_settings = {
      :address   => "smtp.mandrillapp.com",
      :port      => 25, # ports 587 and 2525 are also supported with STARTTLS
      :enable_starttls_auto => true, # detects and uses STARTTLS
      :user_name => ENV["MANDRILL_USERNAME"],
      :password  => ENV["MANDRILL_PASSWORD"], # SMTP password is any valid API key
      :authentication => 'login', # Mandrill supports 'plain' or 'login'
      # :domain => 'heroku.com', # your domain to identify your server when connecting
    }

  end
  
  # Load Google Analytics tracking ID
  if ENV['GOOGLE_ANALYTICS_CERTIFICATE']
    GA.tracker = ENV['GOOGLE_ANALYTICS_CERTIFICATE']
  end

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


