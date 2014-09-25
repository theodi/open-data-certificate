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
    respond_to do |want|
      want.html
      want.csv do
        csv = CSV.generate do |csv|
          csv << [
            "Success?",
            "Published?",
            "Documentation URL",
            "Certificate URL",
            "User"
          ]
          @campaign.certificate_generators.each do |gen|
            csv << [
              "true",
              gen.certificate.published?,
              gen.dataset.documentation_url,
              dataset_certificate_url(gen.dataset, gen.certificate),
              gen.dataset.user.email
            ]
          end
        end
        send_data csv, filename: "#{@campaign.name}.csv", type: "text/csv; header=present; charset=utf-8"
      end
    end
  end

  private
  
  def get_campaign
    @campaign = CertificationCampaign.find_by_name(params[:id])
    raise ActiveRecord::RecordNotFound unless @campaign # why is this necessary?
  end

end
