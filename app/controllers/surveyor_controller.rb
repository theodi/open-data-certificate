class SurveyorController < ApplicationController
  unloadable
  include Surveyor::SurveyorControllerMethods

  before_filter :set_response_set_and_render_context
  before_filter :ensure_modifications_allowed, only: [:continue, :edit, :update]


  layout 'application'

  # this is now in the application_controller
  def create
    params[:survey_access_code] = params[:survey_code]
    start_questionnaire
  end

  def continue
    if @response_set.survey.superceded? && @response_set.incomplete? # This is a double-check, as the filter should stop incomplete response sets getting this far... but just in case, since this is a destructive method...
      # If a newer version of the survey has been released for an incomplete response_set, then upgrade to the new survey
      # and delete the old responses.
      # TODO: determine if this is actually what is wanted, or if a more interactive user experience is preferred
      new_response_set = ResponseSet.
        create(:survey => Survey.newest_survey_for_access_code(@response_set.survey.access_code),
               :user_id => (current_user.nil? ? current_user : current_user.id),
               :dataset_id => @response_set.dataset_id
      )
      new_response_set.copy_answers_from_response_set!(@response_set)
      @response_set.destroy

      @response_set = new_response_set
    end
    redirect_to surveyor.edit_my_survey_path(survey_code: @response_set.survey.access_code, response_set_code: @response_set.access_code)
  end

  def force_save_questionnaire
    # This action is used when the user has signed-in after clicking the "save and finish" link. It mocks up the request as if it were an already-logged-in user that clicked "save and finish"
    params[:finish] = true
    update
  end

  def update
    if @response_set

      if @response_set.complete?
        return redirect_with_message(surveyor_index, :notice, t('surveyor.that_response_set_is_complete'))
      end

      # Remove and track the finish trigger to prevent surveyor completing the survey premuturely
      finish = params.delete(:finish)

      saved = load_and_update_response_set_with_retries

      if saved && finish
        if user_signed_in? && @response_set.all_mandatory_questions_complete?
          @response_set.complete!
          @response_set.save
          return redirect_with_message(surveyor_finish, :notice, t('surveyor.completed_survey'))
        end

        if user_signed_in?
          message = t('surveyor.all_mandatory_questions_need_to_be_completed')
        else
          message = t('surveyor.must_be_logged_in_to_complete')
        end

        return redirect_with_message(
          surveyor.edit_my_survey_path(
            :anchor => anchor_from(params[:section]),
            :section => section_id_from(params),
            :highlight_mandatory => true
          ),
          :warning, message
        )
      end
    end

    respond_to do |format|
      format.html do
        if @response_set
          flash[:notice] = t('surveyor.unable_to_update_survey') unless saved
          redirect_to surveyor.edit_my_survey_path(:anchor => anchor_from(params[:section]), :section => section_id_from(params))
        else
          redirect_with_message(surveyor.available_surveys_path, :notice, t('surveyor.unable_to_find_your_responses'))
        end
      end
      format.js do
        if @response_set
          question_ids_for_dependencies = (params[:r] || []).map { |k, v| v["question_id"] }.compact.uniq
          render :json => @response_set.reload.all_dependencies(question_ids_for_dependencies)
        else
          render :text => "No response set #{params[:response_set_code]}", :status => 404
        end
      end
    end
  end

  def requirements
    if @response_set

      @requirements = @response_set.outstanding_requirements
      @mandatory_fields = @response_set.incomplete_triggered_mandatory_questions

      respond_to do |format|
        format.html
        format.json { @response_set.outstanding_requirements.to_json }
      end
    else
      flash[:notice] = t('surveyor.unable_to_find_your_responses')
      redirect_to surveyor_index
    end
  end


  # where to send the user once the survey has been completed
  # if there was a dataset, go back to it
  private
  def surveyor_finish
    dashboard_path
  end

  private
  def ensure_modifications_allowed
    unless @response_set.modifications_allowed?
      flash[:notice] = t('surveyor.modifications_not_allowed')
      redirect_to dashboard_path
    end
  end

  private
  def set_response_set_and_render_context
    super
    authorize!(:edit, @response_set) if @response_set
  end

end
