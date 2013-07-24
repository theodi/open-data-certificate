class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js

  def edit
    @surveys = Survey.available_to_complete
    super
  end
end