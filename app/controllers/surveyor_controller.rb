class SurveyorController < ApplicationController
  unloadable
  include Surveyor::SurveyorControllerMethods

  before_filter :set_response_set_and_render_context
  before_filter :ensure_modifications_allowed, only: [:edit, :update]


  layout 'application'

  # this is now in the application_controller
  def create
    params[:survey_access_code] = params[:survey_code]
    start_questionnaire
  end

  # it might be a *really* nice refactor to take this to response_set_controller#update
  # then we could use things like `form_for [surveyor, response_set] do |f|`
  #
  # also, GET here is totally totally wrong
  def continue
    if params[:survey_locale]
      @response_set.update_attribute :locale, params[:survey_locale]

    elsif Survey::MIGRATIONS.has_key? params[:survey_code]
      # lets switch over to the new questionnaire
      nxt = Survey::MIGRATIONS[params[:survey_code]]

      survey = Survey.newest_survey_for_access_code nxt

      unless survey.nil?
        attrs = @response_set.attributes.keep_if do |key|
          %w(user_id dataset_id).include? key
        end
        attrs[:survey_id] = survey.id;
        new_response_set = ResponseSet.create attrs

        new_response_set.copy_answers_from_response_set!(@response_set)
        # @response_set.destroy

        @response_set = new_response_set
      end

    elsif params[:juristiction_access_code]
      # they *actually* want to swap the jurisdiction

      survey = Survey.newest_survey_for_access_code(params[:juristiction_access_code])
      unless survey.nil?
        attrs = @response_set.attributes.keep_if do |key|
          %w(user_id dataset_id).include? key
        end
        attrs[:survey_id] = survey.id;
        new_response_set = ResponseSet.create attrs

        new_response_set.copy_answers_from_response_set!(@response_set)
        # @response_set.destroy

        @response_set = new_response_set

        # the user has made a concious effort to switch jurisdictions, so set it as their default
        if user_signed_in?
          current_user.update_attributes default_jurisdiction: params[:juristiction_access_code]
        end

      end

    elsif !@response_set.modifications_allowed?
      # they *actually* want to create a new response set

      attrs = @response_set.attributes.keep_if do |key|
        %w(survey_id user_id dataset_id).include? key
      end
      new_response_set = ResponseSet.create attrs
      new_response_set.copy_answers_from_response_set!(@response_set)

      @response_set = new_response_set

    elsif @response_set.survey.superceded? && @response_set.draft? # This is a double-check, as the filter should stop incomplete response sets getting this far... but just in case, since this is a destructive method...
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

      if @response_set.published?
        return redirect_with_message(surveyor_index, :warning, t('surveyor.response_set_is_published'))
      end

      # Remove and track the finish trigger to prevent surveyor completing the survey premuturely
      finish = params.delete(:finish)

      saved = load_and_update_response_set_with_retries

      urls_resolve = @response_set.all_urls_resolve?

      if saved && finish

        if user_signed_in?
          if @response_set.all_mandatory_questions_complete? == false
            flash[:alert] = t('surveyor.all_mandatory_questions_need_to_be_completed')
          end

          unless urls_resolve
            flash[:warning] = t('surveyor.please_check_all_your_urls_exist')
          end

          if @response_set.all_mandatory_questions_complete? && urls_resolve
            @response_set.complete!
            @response_set.save

            return redirect_with_message(surveyor_finish, :notice, t('surveyor.completed_survey'))
          end
        else
          flash[:alert] = t('surveyor.must_be_logged_in_to_complete')
        end

        return redirect_to(surveyor.edit_my_survey_path(
          :anchor => anchor_from(params[:section]),
          :section => section_id_from(params),
          :highlight_mandatory => true
        ))
      end
    end

    respond_to do |format|
      format.html do
        if @response_set
          flash[:warning] = t('surveyor.unable_to_update_survey') unless saved
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

  def repeater_field
    question = Question.find(params[:question_id])
    @rc = params[:response_index].to_i
    render :partial => "partials/repeater_field", locals: {response_group: params[:response_group] || 0, question: question}
  end

  def requirements
    if @response_set
      redirect_to improvements_dataset_certificate_path(@response_set.dataset, @response_set.certificate)
    else
      flash[:warning] = t('surveyor.unable_to_find_your_responses')
      redirect_to surveyor_index
    end
  end

  def edit
    # @response_set is set in before_filter - set_response_set_and_render_context
    if @response_set
      @survey = @response_set.survey
      @sections = @survey.sections.with_includes
      @dependents = []
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
      flash[:warning] = t('surveyor.modifications_not_allowed')
      redirect_to dashboard_path
    end
  end

  private
  def set_response_set_and_render_context
    super
    authorize!(:edit, @response_set) if @response_set
  end

end
