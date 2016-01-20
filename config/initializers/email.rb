require 'email_logger'

if Rails.env.development?
  ActionMailer::Base.register_interceptor(EmailLogger.new)
end
