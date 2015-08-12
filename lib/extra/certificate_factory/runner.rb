module CertificateFactory
  class FactoryRunner
    include Sidekiq::Worker

    def perform(options)
      if campaign_id = options.delete('campaign_id')
        options['campaign'] = CertificationCampaign.find(campaign_id)
      end
      CertificateFactory::Factory.new(options).build
    end
  end

  class CSVFactoryRunner
    include Sidekiq::Worker

    def perform(options)
      if campaign_id = options.delete('campaign_id')
        options['campaign'] = CertificationCampaign.find(campaign_id)
      end
      CertificateFactory::CSVFactory.new(options).build
    end
  end
end
