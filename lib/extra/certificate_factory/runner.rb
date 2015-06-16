module CertificateFactory
  class FactoryRunner
    include Sidekiq::Worker

    def perform(options)
      CertificateFactory::Factory.new(options).build
    end
  end

  class CSVFactoryRunner
    include Sidekiq::Worker

    def perform(options)
      CertificateFactory::CSVFactory.new(options).build
    end
  end
end
