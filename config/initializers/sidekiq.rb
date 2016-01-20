Sidekiq.hook_rails!
Sidekiq.remove_delay!

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['ODC_REDIS_SERVER_URL'] }

  config.failures_default_mode = :all
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['ODC_REDIS_SERVER_URL'] }
end
