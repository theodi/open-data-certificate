class JurisdictionsController < ApplicationController
  def index
    @jurisdictions = Survey.available_to_complete
                           .select([:title, :full_title, :status])
                           .map &:attributes

    render json: @jurisdictions
  end
end
