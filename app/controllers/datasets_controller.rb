class DatasetsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :show

  before_filter :authenticate_user!, only: :dashboard
  before_filter :authenticate_user_from_token!, only: [:create, :update_certificate, :import_status]
  before_filter(:only => [:show, :index]) { alternate_formats [:feed, :json] }
  before_filter :jurisdiction_required, only: :create
  before_filter :dataset_information_required, only: :create
  before_filter :no_published_certificate_exists, only: :create

  before_filter :clean_params, only: :index

  def info
    respond_to do |format|
      format.json do
        render json: {
          published_certificate_count: Dataset.published_count
        }
      end
    end
  end

  def index

    datasets = Dataset
                .where(removed: false)
                .includes(:response_set, :certificate)
                .joins(:response_set)
                .order('certificates.published_at DESC')

    @title = t('datasets.datasets')

    if params[:jurisdiction].presence
      datasets = datasets.joins(response_set: :survey)
                           .merge(Survey.where(title: params[:jurisdiction]))
    end

    if params[:publisher].presence
      datasets = datasets.joins(response_set: :certificate)
                           .merge(Certificate.where(curator: params[:publisher]))
    end

    if level = params[:level].presence
      datasets = datasets.merge(Certificate.where(attained_level: level))
    end

    if datahub = params[:datahub].presence
      datasets = datasets.where(
        "documentation_url like ? or documentation_url like ?",
        "http://#{datahub}%",
        "https://#{datahub}%")
    end

    if term = params[:search].presence
      @title = t('datasets.search_results')

      datasets = datasets.joins(:certificate)
        .joins({response_set: :survey})
        .reorder('')
        .search(
          m: 'or',
          certificates_name_cont: term,
          certificates_curator_cont: term,
          survey_full_title_cont: term)
        .result
    end

    @datasets = datasets.page params[:page]

    respond_to do |format|
      format.html
      format.json
      format.feed { render :layout => false  }
    end
  end

  def typeahead
    # responses for the autocomplete, gives results in
    # [{title:"the match title", path:"/some/path"},…]
    @response = case params[:mode]
      when 'dataset'
        Dataset.search({title_cont:params[:q]}).result
               .includes(:response_set)
               .merge(ResponseSet.published)
               .limit(5).map do |dataset|
          {
            value: dataset.title,
            path: dataset_path(dataset),
            attained_index: dataset.response_set.try(:attained_index)
          }
        end
      when 'publisher'
        Certificate.search({curator_cont:params[:q]}).result
                .where(Certificate.arel_table[:curator].not_eq(nil))
                .includes(:response_set).merge(ResponseSet.published)
                .group(:curator)
                .limit(5).map do |dataset|
          {
            value: dataset.curator,
            path:  datasets_path(publisher:dataset.curator)
          }
        end
      when 'country'
        Survey.search({full_title_cont:params[:q]}).result
              .joins(:response_sets).merge(ResponseSet.published)
              .group(:title)
              .order(:survey_version)
              .limit(5).map do |survey|
          {
            value: survey.full_title,
            path: datasets_path(jurisdiction:survey.title)
          }
        end
      else
        []
      end

    render json: @response
  end

  def dashboard
    if current_user
      @datasets = current_user.datasets.with_responses.page params[:page]
    end
    @surveys = Survey.available_to_complete

    respond_to do |format|
      format.html
    end
  end

  def show
    @certificates = @dataset.certificates.where(:published => true).by_newest

    respond_to do |format|
      format.html
      format.feed { render :layout => false }
      format.json { render :json => @dataset.generation_result }
    end
  end

  # currently only used by an admin to remove an item from the public view
  def update
    authorize! :manage, @dataset
    @dataset.update_attribute :removed, params[:dataset][:removed]
    redirect_to @dataset
  end

  def admin
    authorize! :manage, @datasets
    @datasets = Dataset.where(removed: true).page params[:page]
    @title = "Admin - **removed** datasets"
  end

  def create
    jurisdiction, dataset, create_user = params.values_at(:jurisdiction, :dataset, :create_user)
    generator = CertificateGenerator.create(
      request: dataset,
      user: current_user,
      certification_campaign: campaign
    )
    generator.delay.generate(jurisdiction, create_user)
    render status: :accepted, json: {
      success: "pending",
      dataset_id: params[:existing_dataset].try(:id),
      dataset_url: status_datasets_url(generator)
    }
  end

  def import_status
    generator = CertificateGenerator.find(params[:certificate_generator_id])
    authorize! :read, generator
    if generator.completed?
      redirect_to generator.dataset_url
    else
      render json: {success: "pending", dataset_id: nil, dataset_url: status_datasets_url(generator)}
    end
  end

  def update_certificate
    jurisdiction, dataset = params.values_at(:jurisdiction, :dataset)
    dataset_model = Dataset.find(params[:dataset_id])
    render json: CertificateGenerator.update(dataset_model, dataset, jurisdiction, current_user)
  end

  def schema
    render json: CertificateGenerator.schema(params)
  end

  protected
  def jurisdiction_required
    unless Survey.by_jurisdiction(params[:jurisdiction]).exists?
      render status: :unprocessable_entity, json: {success: false, errors: ['Jurisdiction not found']}
    end
  end

  def dataset_information_required
    unless params[:dataset].present?
      render status: :unprocessable_entity, json: {success: false, errors: ['Dataset information required']}
    end
  end

  def campaign
    @campaign_name ||= params.fetch(:campaign, :nil_but_true)
    unless @campaign_name == :nil_but_true
      @campaign ||= CertificationCampaign.where(:user_id => current_user.id).find_or_create_by_name(@campaign_name)
    end
  end

  def no_published_certificate_exists
    documentation_url = params[:dataset][:documentationUrl]
    existing_dataset = Dataset.where(documentation_url: documentation_url).first
    if existing_dataset.try(:certificate).present?
      campaign.increment!(:duplicate_count) if campaign
      render status: :unprocessable_entity, json: {
        success: false,
        errors: ['Dataset already exists'],
        dataset_id: existing_dataset.id,
        dataset_url: existing_dataset.api_url
      }
    else
      params[:existing_dataset] = existing_dataset if existing_dataset
    end
  end

  def clean_params
    params.delete('utf8')
    params.each do |key, value|
      params.delete(key) unless value.present?
    end
  end
end
