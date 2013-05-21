class SurveyorController < ApplicationController
  unloadable
  include Surveyor::SurveyorControllerMethods

  layout 'application'

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

      question_ids_for_dependencies = (params[:r] || []).map { |k, v| v["question_id"] }.compact.uniq
      saved = load_and_update_response_set_with_retries

      if saved && params[:finish]
        if all_mandatory_questions_complete?
          return redirect_with_message(surveyor_finish, :notice, t('surveyor.completed_survey'))
        else
          @response_set.incomplete!
          return redirect_with_message(surveyor.edit_my_survey_path(:anchor => anchor_from(params[:section]), :section => section_id_from(params)), :warning, t('surveyor.all_mandatory_questions_need_to_be_completed'))
        end
      end

      respond_to do |format|
        format.html do
          if @response_set.nil?
            return redirect_with_message(surveyor.available_surveys_path, :notice, t('surveyor.unable_to_find_your_responses'))
          else
            flash[:notice] = t('surveyor.unable_to_update_survey') unless saved
            redirect_to surveyor.edit_my_survey_path(:anchor => anchor_from(params[:section]), :section => section_id_from(params))
          end
        end
        format.js do
          if @response_set
            render :json => @response_set.reload.all_dependencies(question_ids_for_dependencies)
          else
            render :text => "No response set #{params[:response_set_code]}",
                   :status => 404
          end
        end
      end

    end
  end

  def attained_level
    set_response_set_and_render_context
    if @response_set
      respond_to do |format|
        format.html
        format.json { @response_set.attained_level.to_json }
      end
    else
      flash[:notice] = t('surveyor.unable_to_find_your_responses')
      redirect_to surveyor_index
    end
  end

  def requirements
    set_response_set_and_render_context
    if @response_set
      respond_to do |format|
        format.html
        format.json { @response_set.outstanding_requirements.to_json }
      end
    else
      flash[:notice] = t('surveyor.unable_to_find_your_responses')
      redirect_to surveyor_index
    end
  end

  private
  def all_mandatory_questions_complete?
    #@response_set.reload
    mandatory_question_ids = @response_set.triggered_mandatory_questions.map(&:id)
    responded_to_question_ids = @response_set.responses.map(&:question_id)
    (mandatory_question_ids - responded_to_question_ids).blank?
  end

  # where to send the user once the survey has been completed
  # if there was a dataset, go back to it
  private
  def surveyor_finish
    if @response_set.dataset
      dataset_path @response_set.dataset
    else
      surveyor.available_surveys_path
    end
  end

  private
  def set_response_set_and_render_context
    super
    authorize!(:edit, @response_set) if @response_set
  end

end