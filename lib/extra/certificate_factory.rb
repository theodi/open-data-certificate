$:.unshift File.dirname(__FILE__)

require 'httparty'
require 'dotenv'

Dotenv.load

require 'certificate_factory/api'
require 'certificate_factory/certificate'
require 'certificate_factory/factory'

module CertificateFactory

end
