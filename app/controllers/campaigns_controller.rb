class CampaignsController < ApplicationController
  include CampaignsHelper

  before_filter :authenticate_user!
  before_filter :get_campaign, except: [:index, :new, :create]

  def index
    @campaigns = CertificationCampaign.where(user_id: current_user)
  end

  def show
    @certificate_level = params.fetch("certificate_level", "uncertified")
    @generators = @campaign.certificate_generators.includes(:dataset, :certificate).where(latest: true)
    respond_to do |want|
      want.html do
        @generators = @generators.filter(@certificate_level).page(params[:page]).per(100)
      end
      want.csv do
        csv = CSV.generate do |csv|
          csv << [
            "Success?",
            "Published?",
            "Documentation URL",
            "Certificate URL",
            "User",
            "Missing responses"
          ]
          @generators.each do |gen|
            csv << [
              gen.completed?,
              gen.certificate.published?,
              gen.dataset.documentation_url,
              dataset_certificate_url(gen.dataset, gen.certificate),
              gen.dataset.user_email,
              missing_responses(gen)
            ]
          end
        end
        send_data csv, filename: "#{@campaign.name}.csv", type: "text/csv; header=present; charset=utf-8"
      end
    end
  end

  def rerun
    authorize! :manage, @campaign

    @campaign.rerun!
    flash[:notice] = "Campaign queued for rerun"

    redirect_to campaign_path(@campaign, certificate_level: "all")
  end

  def new
    @campaign = CertificationCampaign.new(jurisdiction: current_user.default_jurisdiction)
  end

  def create
    @campaign = current_user.certification_campaigns.create(params[:certification_campaign])
    if @campaign.valid?
      @campaign.run!
      flash[:notice] = "Campaign queued to run"
      redirect_to campaign_path(@campaign, certificate_level: "all")
    else
      render :action => 'new'
    end
  end

  def schedule
    authorize! :manage, @campaign

    @campaign.scheduled_rerun
    flash[:notice] = "Campaign scheduled to run daily"

    redirect_to campaign_path(@campaign)
  end

  private

  def get_campaign
    @campaign = CertificationCampaign.find(params[:id] || params[:campaign_id])
    authorize! :read, @campaign
  end

end
