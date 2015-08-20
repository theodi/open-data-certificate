class CertificationCampaignWorker
  include Sidekiq::Worker

  def perform(id)
    campaign = CertificationCampaign.find(id)
    campaign.scheduled_rerun
  end

end

