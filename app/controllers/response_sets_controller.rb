require 'odibot'

# Trying out having a separate controller from the central surveyor one.
class ResponseSetsController < ApplicationController

  load_and_authorize_resource

  def destroy
    @response_set.destroy
    redirect_to dashboard_path, notice: t('dashboard.deleted_response_set')
  end

  def publish
    begin
      @response_set.publish!
      redirect_to dashboard_path, notice: t('dashboard.published_response_set')
    rescue AASM::InvalidTransition
      redirect_to dashboard_path, alert: t('dashboard.unable_to_publish_response_set_invalid')
    end
  end

  def resolve
    render json: {valid: ODIBot.valid?(params[:url])}
  end

  # Check the user's documentation url and populate answers from it
  def start
    @documentation_url, url_explanation = params[:response_set].values_at(
        :documentation_url, :documentation_url_explanation)
    if request.put?
      valid = false
      if ODIBot.valid?(@documentation_url)
        @response_set.autocomplete(@documentation_url)
        valid = true
      elsif url_explanation.present?
        @response_set.documentation_url = @documentation_url
        @response_set.documentation_url_explanation = url_explanation
        @response_set.save
        valid = true
      end

      if valid
        path = edit_my_survey_path(:response_set_code => @response_set.access_code)
        respond_to do |format|
          format.html { redirect_to(path) }
          format.json { render json: { survey_path: path } }
        end
      else
        @url_error = true
        @survey = @response_set.survey
        respond_to do |format|
          format.html { render 'surveyor/start.html.haml' }
          format.json { head status: 404 }
        end
      end
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboard_path, alert: t('dashboard.unable_to_access_response_set')
  end

end
