module Sidekiq::Extensions::Klass
  alias :sidekiq_delay :delay
  remove_method :delay
  alias :sidekiq_delay_for :delay_for
  remove_method :delay_for
  alias :sidekiq_delay_until :delay_until
  remove_method :delay_until
end

module Sidekiq::Extensions::ActiveRecord
  alias :sidekiq_delay :delay
  remove_method :delay
  alias :sidekiq_delay_for :delay_for
  remove_method :delay_for
  alias :sidekiq_delay_until :delay_until
  remove_method :delay_until
end

module Sidekiq::Extensions::ActionMailer
  alias :sidekiq_delay :delay
  remove_method :delay
  alias :sidekiq_delay_for :delay_for
  remove_method :delay_for
  alias :sidekiq_delay_until :delay_until
  remove_method :delay_until
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['ODC_REDIS_SERVER_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['ODC_REDIS_SERVER_URL'] }
end
