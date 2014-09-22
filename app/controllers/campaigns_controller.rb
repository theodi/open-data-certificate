class CampaignsController < ApplicationController

  def index
    @campaigns = CertificationCampaign.all
  end

end
