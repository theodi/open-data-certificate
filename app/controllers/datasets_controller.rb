class DatasetsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :show

  before_filter :authenticate_user!, only: :dashboard
  before_filter(:only => [:show, :index]) { alternate_formats [:feed] }

  def index

    @datasets = Dataset
                .where(removed: false)
                .includes(:response_set, :certificate)
                .joins(:response_set)
                .order('response_sets.attained_index DESC')
    
    @title = t('datasets.datasets')

    if params[:jurisdiction]
      @datasets = @datasets.joins(response_set: :survey)
                           .merge(Survey.where(title: params[:jurisdiction]))
    end

    if params[:publisher]
      @datasets = @datasets.joins(response_set: :certificate)
                           .merge(Certificate.where(curator: params[:publisher]))
    end

    if params[:search]
      @title = t('datasets.search_results')
      
      base = @datasets.joins(:certificate).joins({response_set: :survey}).reorder('')

      # this is far from ideal - loads in all matches then limits for pagination
      results = base.merge(Certificate.search(name_cont: params[:search]).result).all +
                base.merge(Certificate.search(curator_cont: params[:search]).result).all +
                base.merge(Survey.search(full_title_cont: params[:search]).result).all

      @datasets = Kaminari.paginate_array(results.flatten.uniq).page params[:page]
    else
      @datasets = @datasets.page params[:page]
    end
        
    respond_to do |format|
      format.html
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

end
