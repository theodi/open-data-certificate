class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js

  helper_method :campaigns, :surveys
  
  prepend_before_action :check_captcha, only: [:create]
  
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
  
  private

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides Recaptcha
      respond_with_navigational(resource) { render :new }
    end 
  end
  
end
