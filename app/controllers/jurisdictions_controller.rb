class JurisdictionsController < ApplicationController
  def index
    @jurisdictions = Survey.available_to_complete
                           .select([:title, :full_title, :status, :access_code])
                           .map &:attributes

    render json: @jurisdictions
  end
end
