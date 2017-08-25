$:.unshift File.dirname(__FILE__)

require 'httparty'
require 'dotenv'
require 'sidekiq'

Sidekiq::Extensions.enable_delay!
Dotenv.load

require 'certificate_factory/api'
require 'certificate_factory/certificate'
require 'certificate_factory/factory'
require 'certificate_factory/runner'

module CertificateFactory

end
