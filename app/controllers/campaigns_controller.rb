class CampaignsController < ApplicationController
  include CampaignsHelper

  before_filter :authenticate_user!
  before_filter :get_campaign, except: [:index]

  def index
    @campaigns = CertificationCampaign.where(user_id: current_user)
  end

  def show
    @generators = @campaign.certificate_generators.includes(:dataset, :certificate)
    respond_to do |want|
      want.html do
        @generators = @generators.page(params[:page]).per(100)
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

  private

  def get_campaign
    @campaign = CertificationCampaign.find(params[:id])
    authorize! :read, @campaign
  end

end
