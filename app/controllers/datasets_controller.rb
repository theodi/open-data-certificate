class DatasetsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :show

  before_filter :authenticate_user!, only: :dashboard
  before_filter :authenticate_user_from_token!, only: [:create, :update_certificate]
  before_filter(:only => [:show, :index]) { alternate_formats [:feed] }

  def index
    @datasets = Dataset.show_all(params[:format])
    @title = t('datasets.datasets')

    @datasets = @datasets.view_by_jurisdiction(params[:jurisdiction]) if params[:jurisdiction]
    @datasets = @datasets.view_by_publisher(params[:publisher]) if params[:publisher]
    @datasets = @datasets.page params[:page]

    respond_to do |format|
      format.html
      format.feed { render :layout => false  }
    end
  end

  def search
    @title = t('datasets.search_results')
    results = Dataset.multi_search(params[:search])
    @datasets = Kaminari.paginate_array(results).page params[:page]

    respond_to do |format|
      format.html { render :template => 'datasets/index' }
      format.feed { render :template => 'datasets/index', :layout => false  }
    end
  end

  def typeahead
    # responses for the autocomplete, gives results in
    # [{title:"the match title", path:"/some/path"},…]
    query = TypeaheadQuery.new(params[:q])
    @response = query.send(params[:mode].to_sym) rescue []

    render json: @response
  end

  def dashboard
    @datasets = current_user.try(:datasets) || []
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
    render json: CertificateGenerator.generate(params, current_user)
  end

  def update_certificate
    @dataset = Dataset.find(params[:dataset_id])
    render json: CertificateGenerator.update(@dataset, params, current_user)
  end

  def schema
    render json: CertificateGenerator.schema(params)
  end
end
