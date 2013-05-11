class DatasetsController < ApplicationController
  def new
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.new(params[:dataset])

    # update with the logged in user
    if user_signed_in?
      @dataset.user = current_user
    end

    if @dataset.save
      redirect_to @dataset
    else
      render 'new'
    end

  end

  def index
    @datasets = current_user ? current_user.datasets : []
  end

  def show
    @dataset = Dataset.find params[:id]

    if @dataset.user.nil? && user_signed_in?
      # give the unclaimed dataset to the user
      @dataset.user = current_user
      @dataset.save
    end
  end

  # mostly lifted from surveyor#create
  def start_questionnaire
    @dataset = Dataset.find params[:dataset_id]

    surveys = Survey.order("survey_version DESC")
    
    # use the most recent survey for now
    @survey = surveys.first

    @response_set = @dataset.response_sets.
      create(:survey => @survey, :user_id => (current_user.nil? ? current_user : current_user.id))
    if (@survey && @response_set)
      flash[:notice] = t('surveyor.survey_started_success')
      redirect_to(surveyor.edit_my_survey_path(
        :survey_code => @survey.access_code, :response_set_code  => @response_set.access_code))
    else
      flash[:notice] = t('surveyor.Unable_to_find_that_survey')
      redirect_to @dataset
    end
  end

end
