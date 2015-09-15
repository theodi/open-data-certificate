module CertificateFactory
  class FactoryRunner
    include Sidekiq::Worker

    def perform(options)
      if campaign_id = options.delete('campaign_id')
        options['campaign'] = CertificationCampaign.find(campaign_id)
      end
      factory = case options['feed']
      when /.atom$/
        CertificateFactory::AtomFactory.new(options)
      else
        CertificateFactory::CKANFactory.new(options)
      end
      factory.build
    end
  end
end
