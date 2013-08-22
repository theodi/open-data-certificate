class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js

  def edit
    if params[:id].to_i == current_user.id
      @surveys = Survey.available_to_complete
      super
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def update
    @surveys = Survey.available_to_complete
    super
  end

  def redirect
    id = current_user.id
    redirect_to edit_user_registration_path id
  end

  protected
  def after_update_path_for(resource)
    dashboard_path(resource)
  end
end
