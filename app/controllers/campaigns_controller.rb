require 'odibot'

class CampaignsController < ApplicationController
  include CampaignsHelper

  before_filter :authenticate_user!
  before_filter :get_campaign, except: [:index, :new, :create, :endpoint_check, :precheck, :template_typeahead]

  def index
    @campaigns = CertificationCampaign.where(user_id: current_user)
  end

  def show
    @certificate_level = params.fetch("certificate_level", "all")
    @generators = @campaign.certificate_generators.includes(:dataset, :certificate).where(latest: true)
    respond_to do |want|
      want.html do
        @generators = @generators.filter(@certificate_level).page(params[:page]).per(100)
      end

      want.js do 
        @generators = @generators.filter(@certificate_level).page(params[:page]).per(100)
        render 'campaign_certificates'
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

  def queue_update
    authorize! :manage, @campaign
    certificate_level = params.fetch("certificate_level", "all")
    
    generators = @campaign.certificate_generators.includes(:dataset).where(latest: true)
    generators = generators.filter(certificate_level)

    result = CertificateGenerator.bulk_update(generators, @campaign.jurisdiction, @campaign.user)
    
    flash[:notice] = "#{certificate_level.capitalize} certificates queued for update"
    redirect_to campaign_path(@campaign, certificate_level: certificate_level)
  end

  def schedule
    authorize! :manage, @campaign

    @campaign.scheduled_rerun
    flash[:notice] = "Campaign scheduled to run daily"

    redirect_to campaign_path(@campaign)
  end

  def endpoint_check
    success = false
    campaign_url = params.fetch("campaign_url")
    result = ODIBot.new(campaign_url).check_ckan_endpoint
    render :json => result
  end

  def precheck
    limit = params["limit"].blank? ? nil : params["limit"].to_i
    include_harvested = params.fetch("include_harvested", false)
    include_harvested = include_harvested.eql?("true")

    campaign = current_user.certification_campaigns.build(url: params.fetch("campaign_url"), 
      subset: params.fetch("subset"), limit: limit, template_dataset_id: params.fetch("template_dataset_id"), 
      include_harvested: include_harvested)
    
    factory = CertificateFactory::CKANFactory.new({ is_prefetch: true, campaign: campaign, rows:3, params:{}, limit: 3, 
      include_harvested: include_harvested })

    @generators = factory.prebuild

    if @generators.blank? 
      @result_count = 0 
    else
      @result_count = factory.result_count
      @result_count -= factory.skipped
      @result_count = limit if !limit.blank? and (limit < @result_count)
    end

    respond_to do |format|
      format.js
    end
  end

  def template_typeahead
    survey = Survey.newest_survey_for_access_code(params[:jurisdiction])
    @response = []
    if survey
      datasets = current_user.datasets.joins(:response_sets)
        .where('response_sets.aasm_state' => "draft").where('response_sets.survey_id' => survey.id)
      @response = datasets.search({title_cont:params[:q]}).result.limit(5).map do |dataset|
        {
          value: dataset.title,
          attained_index: dataset.response_set.try(:attained_index),
          id: dataset.id
        }
      end
    end
    render json: @response
  end

  private

  def get_campaign
    @campaign = CertificationCampaign.find(params[:id] || params[:campaign_id])
    authorize! :read, @campaign
  end

end
