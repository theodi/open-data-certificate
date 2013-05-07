class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods

  def edit
    if @response_set && @response_set.complete?
      flash[:notice] = t('surveyor.that_response_set_is_complete')
      redirect_to surveyor_index
    else
      super
    end
  end

  def update
    set_response_set_and_render_context
    if @response_set && @response_set.complete?
      flash[:notice] = t('surveyor.that_response_set_is_complete')
      redirect_to surveyor_index
    else
      super
    end
  end

end