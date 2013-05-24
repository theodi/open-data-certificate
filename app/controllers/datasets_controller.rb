class DatasetsController < ApplicationController
  load_and_authorize_resource

  before_filter :authenticate_user!

  def new
  end

  def create
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
    @surveys = Survey.available_to_complete
  end

  def show
    @surveys = Survey.available_to_complete
  end

end
