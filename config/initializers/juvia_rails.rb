JuviaRails.configure do |config|
  config.server_url    = 'http://juvia.theodi.org' #ENV['JUVIA_SERVER_URL']
  config.site_key      = '70gibwaloj9uzoefjpkzjvo9p9gsjmv' #ENV['JUVIA_SITE_KEY']
  config.comment_order = 'earliest-first'
end