class CampaignsController < ApplicationController

  before_filter :get_campaign, except: [:index]

  def index
    @campaigns = CertificationCampaign.all
  end

  def show
    @total_count = @campaign.certificate_generators.count + @campaign.duplicate_count
    @published_count = @campaign.certificate_generators.inject(0) do |total, cert| 
      if cert.certificate.published? 
        total += 1 
      else
        total
      end
    end
  end

  private
  
  def get_campaign
    @campaign = CertificationCampaign.find_by_name(params[:id])
    raise ActiveRecord::RecordNotFound unless @campaign # why is this necessary?
  end

end
