module CertificateFactory
  class FactoryRunner
    include Sidekiq::Worker

    def perform(options)
      factory = options.delete('factory').constantize
      factory.new(options).build
    end
  end
end
