$:.unshift File.dirname(__FILE__)

require 'httparty'
require 'dotenv'
require 'sidekiq'

Sidekiq.hook_rails!
Dotenv.load

require 'certificate_factory/api'
require 'certificate_factory/certificate'
require 'certificate_factory/factory'
require 'certificate_factory/runner'

module CertificateFactory

end
