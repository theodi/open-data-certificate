# Trying out having a separate controller from the central surveyor one.
class ResponseSetsController < ApplicationController

  def destroy
    @response_set = ResponseSet.find params[:id]

    if current_user && @response_set.user == current_user
      @response_set.destroy
      redirect_to dashboard_path, :notice => t('dashboard.deleted_response_set')
    else
      redirect_to dashboard_path, status: 304, :notice => t('dashboard.unable_to_delete_response_set')
    end

  end

  def publish
    @response_set = ResponseSet.find params[:id]

    if current_user && @response_set.user == current_user && @response_set.publish!
      redirect_to dashboard_path, :notice => t('dashboard.published_response_set')
    else
      redirect_to dashboard_path, status: 304, :notice => t('dashboard.unable_to_publish_response_set')
    end
    
  end

end