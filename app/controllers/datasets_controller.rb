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
    @surveys = Survey.order("title DESC, survey_version DESC").all.group_by(&:access_code).map{|k,v| v.first}

    if @dataset.user.nil? && user_signed_in?
      # give the unclaimed dataset to the user
      @dataset.user = current_user
      @dataset.save
    end
  end

  # mostly lifted from surveyor#create
  def start_questionnaire
    @dataset = Dataset.find params[:dataset_id]

    if params[:survey_access_code].blank?
      flash[:notice] = t('surveyor.please_choose_a_legislation')
      redirect_to @dataset and return
    end

    surveys = Survey.where(:access_code => params[:survey_access_code]).order("survey_version DESC")
    
    # use the most recent survey for now
    @survey = surveys.first

    @response_set = @dataset.response_sets.
      create(:survey => @survey, :user_id => (current_user.nil? ? current_user : current_user.id))
    if (@survey && @response_set)
      flash[:notice] = t('surveyor.survey_started_success')
      redirect_to(surveyor.edit_my_survey_path(
        :survey_code => @survey.access_code, :response_set_code  => @response_set.access_code))
    else
      flash[:notice] = t('surveyor.unable_to_find_that_legislation')
      redirect_to @dataset
    end
  end

end
