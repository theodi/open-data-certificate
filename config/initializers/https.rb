if Rails.env.production?
  Rack::Request.send(:define_method, :ssl?) { true }
end
