class ContentLocation
  def initialize(app)
    @app = app
    @@exts ||= {}
  end

  def call(env)
    status, headers, response = @app.call(env)
    if File.extname(env['PATH_INFO']).length == 0
      @@exts[env['HTTP_ACCEPT']] ||= Rack::Mime::MIME_TYPES.invert[env['HTTP_ACCEPT']]
      unless @@exts[env['HTTP_ACCEPT']].nil?
        headers['Content-Location'] = env['PATH_INFO'] + @@exts[env['HTTP_ACCEPT']]
      end
    end
    [status, headers, response]
  end
end