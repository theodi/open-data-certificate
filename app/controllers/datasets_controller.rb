class DatasetsController < ApplicationController
  load_and_authorize_resource

  before_filter :authenticate_user!

  def index

  end
  
  def dashboard
    @datasets = current_user.try(:datasets) || []
    @surveys = Survey.available_to_complete
  end

  def show
    @surveys = Survey.available_to_complete
  end

end
