class DatasetsController < ApplicationController
  def new
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.new(params[:dataset])
    render 'new'
  end
end
