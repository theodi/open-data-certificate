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
end