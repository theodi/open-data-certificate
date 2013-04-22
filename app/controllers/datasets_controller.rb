class DatasetsController < ApplicationController
  def new
    @dataset = Dataset.new
  end
end
