class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js

  helper_method :campaigns, :surveys

  def edit
    if params[:id].to_i == current_user.id
      super
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def redirect
    id = current_user.id
    redirect_to edit_user_registration_path id
  end

  protected
  def after_update_path_for(resource)
    dashboard_path(locale: resource.preferred_locale)
  end

  def campaigns
    CertificationCampaign.where(user_id: current_user.id).count
  end
end
