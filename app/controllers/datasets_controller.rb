class DatasetsController < ApplicationController
  def new
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.new(params[:dataset])

    puts @dataset

    if @dataset.save
      redirect_to @dataset
    else
      render 'new'
    end

  end

  def show
    @dataset = Dataset.find params[:id]
  end
end
