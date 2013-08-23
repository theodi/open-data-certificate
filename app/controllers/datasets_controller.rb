class DatasetsController < ApplicationController
  load_and_authorize_resource

  before_filter :authenticate_user!, only: :dashboard

  def index
    @certificates = Certificate.where(:published => true).by_newest.page params[:page]

    if params[:search]
      @certificates = Kaminari.paginate_array([
        @certificates.search_title(params[:search]),
        @certificates.search_publisher(params[:search]),
        @certificates.search_country(params[:search])
      ].flatten.uniq).page params[:page]
    end

    respond_to do |format|
      format.html
    end
  end

  def dashboard
    @datasets = current_user.try(:datasets) || []
    @surveys = Survey.available_to_complete

    respond_to do |format|
      format.html
    end
  end

  def show
    @dataset = Dataset.find(params[:id])
    @certificates = @dataset.certificates.where(:published => true).by_newest

    respond_to do |format|
      format.html
    end
  end

   def to_atom
    @dataset = Dataset.find(params[:dataset_id])

    url = request.original_url
    @atom=XMLFeed::Atom.dataset_to_feed(@dataset,url)
    render xml: @atom.to_xml
  end
end
