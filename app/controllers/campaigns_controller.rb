class CampaignsController < ApplicationController

  before_filter :get_campaign, except: [:index]

  def index
    @campaigns = CertificationCampaign.all
  end

  def show
  end

  private
  
  def get_campaign
    @campaign = CertificationCampaign.find_by_name(params[:id])
    raise ActiveRecord::RecordNotFound unless @campaign # why is this necessary?
  end

end
