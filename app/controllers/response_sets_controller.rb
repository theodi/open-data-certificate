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

  def autofill
    kitten_data = KittenData.where(url: params[:url], response_set_id: @response_set.id).first_or_create

    unless kitten_data.data
      kitten_data.request_data
      kitten_data.save
    end

    if kitten_data.data
      render :json => {
        data_exists: true,
        data: kitten_data.fields
      }
    else
      render :json => {
        data_exists: false
      }
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboard_path, alert: t('dashboard.unable_to_access_response_set')
  end

end
