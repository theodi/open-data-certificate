JuviaRails.configure do |config|
  config.server_url    = ENV['JUVIA_SERVER_URL']
  config.site_key      = ENV['JUVIA_SITE_KEY']
  config.comment_order = 'earliest-first'
end