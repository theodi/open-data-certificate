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
end
