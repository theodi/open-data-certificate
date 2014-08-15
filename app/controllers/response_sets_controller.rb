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

  def resolve_url(url)
    if url =~ /^#{URI::regexp}$/
      ODIBot.new(url).response_code rescue nil
    end
  end

  def resolve
    if code = resolve_url(params[:url])
      Rails.cache.write(params[:url], code)
      render json: {status: code}
    else
      render :nothing => true
    end
  end

  # Check the user's documentation url and populate answers from it
  def start

    url = params[:response_set][:documentation_url]

    @response_set.update_responses({documentationUrl: url})
    @response_set.responses.update_all(autocompleted: false)
    @response_set.update_attribute('kitten_data', nil)

    code = resolve_url(url)

    if code == 200
      kitten_data = KittenData.create(url: url, response_set: @response_set)
      kitten_data.request_data
      kitten_data.save

      @response_set.update_attribute('kitten_data', kitten_data)
      @response_set.update_responses(kitten_data.fields)
    end

    respond_to do |format|
      format.html do
        redirect_to(surveyor.edit_my_survey_path(
          :survey_code => @response_set.survey.access_code,
          :response_set_code => @response_set.access_code
        ))
      end
      format.json do
        render json: {
          survey_path: surveyor.edit_my_survey_path(
            :survey_code => @response_set.survey.access_code,
            :response_set_code => @response_set.access_code
          )
        }
      end
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboard_path, alert: t('dashboard.unable_to_access_response_set')
  end

end
