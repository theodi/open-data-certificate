class DatasetsController < ApplicationController
  load_and_authorize_resource

  before_filter :authenticate_user!, only: :dashboard

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

  def typeahead
    # responses for the autocomplete, gives results in
    # [{title:"the match title", path:"/some/path"},…]
    @response = case params[:mode]
      when 'dataset'
        Dataset.search({title_cont:params[:q]}).result.limit(5).map do |dataset|
          {
            title: dataset.title,
            path: dataset_path(dataset)
          }
        end
      when 'publisher'
        Dataset.search({curator_cont:params[:q]}).result
                .group(:curator)
                .limit(5).map do |dataset|
          {
            title: dataset.curator,
            path:  datasets_path(publisher:dataset.curator)
          }
        end
      when 'country'
        Survey.search({full_title_cont:params[:q]}).result.limit(5).map do |survey|
          {
            title: survey.full_title,
            path: datasets_path(jurisdiction:survey.title)
          }
        end
      else
        []
      end

    render json: @response
  end

  def dashboard
    @datasets = current_user.try(:datasets) || []
    @surveys = Survey.available_to_complete
  end

  def show
    @dataset = Dataset.find(params[:id])
    @certificates = @dataset.certificates.where(:published => true).by_newest
  end
end
