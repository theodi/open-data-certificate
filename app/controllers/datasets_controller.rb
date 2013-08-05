class DatasetsController < ApplicationController
  load_and_authorize_resource

  before_filter :authenticate_user!

  def index
    @certificates = Certificate.where(:published => true).by_newest

    if params[:search]
      @certificates = [
        @certificates.search_title(params[:search]),
        @certificates.search_publisher(params[:search]),
        @certificates.search_country(params[:search])
      ].flatten.uniq
    end
  end

  def dashboard
    @datasets = current_user.try(:datasets) || []
    @surveys = Survey.available_to_complete
  end

  def show
    @surveys = Survey.available_to_complete
  end

end
