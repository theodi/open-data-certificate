class SurveyorController < ApplicationController
  unloadable

  before_filter :get_current_user, only: [:new, :create]
  before_filter :determine_if_javascript_is_enabled, only: [:create, :update]
  before_filter :set_response_set_and_render_context
  before_filter :ensure_modifications_allowed, only: [:edit, :update]

  # it might be a *really* nice refactor to take this to response_set_controller#update
  # then we could use things like `form_for [surveyor, response_set] do |f|`
  def continue
    if Survey::MIGRATIONS.has_key?(@response_set.survey.access_code)
      # lets switch over to the new questionnaire
      nxt = Survey::MIGRATIONS[@response_set.survey.access_code]

      survey = Survey.newest_survey_for_access_code nxt

      unless survey.nil?
        switch_survey(survey)
      end
    elsif params[:juristiction_access_code]
      # they *actually* want to swap the jurisdiction

      survey = Survey.newest_survey_for_access_code(params[:juristiction_access_code])
      unless survey.nil?
        switch_survey(survey)

        # the user has made a concious effort to switch jurisdictions, so set it as their default
        if user_signed_in?
          current_user.update_attributes default_jurisdiction: params[:juristiction_access_code]
        end
      end

    elsif @response_set.survey.superseded?
      latest_survey = Survey.newest_survey_for_access_code(@response_set.survey.access_code)
      unless latest_survey.nil?
        switch_survey(latest_survey)
      end
    elsif !@response_set.modifications_allowed?
      # they *actually* want to create a new response set
      attrs = prepare_new_response_set
      create_new_response_set(attrs)
    end

    redirect_options = {
      response_set_code: @response_set.access_code
    }
    redirect_options[:anchor] = "q_#{params[:question]}" if params[:question]
    if params[:update]
      redirect_options[:update] = true
      flash[:warning] = t('response_set.update_instructions')
    end

    redirect_to edit_my_survey_path(redirect_options)
  end

  def update
    if @response_set.published?
      return redirect_with_message(surveyor_index, :warning, t('surveyor.response_set_is_published'))
    end

    saved = load_and_update_response_set_with_retries

    if saved && !request.xhr?
      flash[:_saved_response_set] = @response_set.access_code

      if user_signed_in?
        mandatory_questions_complete = @response_set.all_mandatory_questions_complete?
        urls_resolve = @response_set.all_urls_resolve?

        unless mandatory_questions_complete
          flash[:alert] = t('surveyor.all_mandatory_questions_need_to_be_completed')
        end

        unless urls_resolve
          flash[:warning] = t('surveyor.please_check_all_your_urls_exist')
        end

        if mandatory_questions_complete && urls_resolve
          @response_set.complete!
          @response_set.save

          if params[:update]
            @response_set.publish!
            return redirect_to(dashboard_path, notice: t('dashboard.updated_response_set'))
          else
            return redirect_with_message(dashboard_path, :notice, t('surveyor.completed_survey'))
          end
        end
      else
        flash[:alert] = t('surveyor.must_be_logged_in_to_complete')
      end

      return redirect_to(edit_my_survey_path({
        :anchor => anchor_from(params[:section]),
        :section => section_id_from(params),
        :highlight_mandatory => true,
        :update => params[:update]
      }.reject! {|k, v| v.nil? }))
    end

    respond_to do |format|
      format.html do
        flash[:warning] = t('surveyor.unable_to_update_survey') unless saved
        redirect_to edit_my_survey_path(:anchor => anchor_from(params[:section]), :section => section_id_from(params))
      end
      format.js do
        question_ids_for_dependencies = (params[:r] || []).map { |k, v| v["question_id"] }.compact.uniq
        render :json => @response_set.reload.all_dependencies(question_ids_for_dependencies)
      end
    end
  end

  def repeater_field
    @responses = @response_set.responses.includes(:question).all
    question = Question.find(params[:question_id])
    @rc = params[:response_index].to_i
    render :partial => "partials/repeater_field", locals: {response_group: params[:response_group] || 0, question: question}
  end

  def requirements
    redirect_to improvements_dataset_certificate_path(@response_set.dataset, @response_set.certificate)
  end

  def edit
    @responses = @response_set.responses.includes(:question).all
    @survey = @response_set.survey
    @sections = @survey.sections.with_includes
    @update = true if params[:update]
  end

  def start
    # this is an alternate view of the edit functionality,
    # with only the documentation url displayed
    edit
    @url_error = @response_set.documentation_url_explanation.present?
  end


  private


  def ensure_modifications_allowed
    unless @response_set.modifications_allowed?
      flash[:warning] = t('surveyor.modifications_not_allowed')
      redirect_to dashboard_path
    end
  end

  def set_response_set_and_render_context
    @response_set = ResponseSet.find_by_access_code!(
      params[:response_set_code],
      include: {
        responses: [:question, :answer]
      }
    )
    @render_context = nil

    authorize!(:edit, @response_set)
  end

  def get_current_user
    @current_user = self.respond_to?(:current_user) ? self.current_user : nil
  end

  def prepare_new_response_set
    keep = %w[survey_id user_id dataset_id]
    @response_set.attributes.slice(*keep)
  end

  # Params: the name of some submit buttons store the section we'd like to go
  # to. for repeater questions, an anchor to the repeater group is also stored
  # e.g. params[:section] = {"1"=>{"question_group_1"=>"<= add row"}}
  def section_id_from(p = {})
    if p[:section] && p[:section].respond_to?(:keys)
      p[:section].keys.first
    elsif p[:section]
      p[:section]
    elsif p[:current_section]
      p[:current_section]
    end
  end

  def anchor_from(p)
    p.respond_to?(:keys) && p[p.keys.first].respond_to?(:keys) ? p[p.keys.first].keys.first : nil
  end

  def surveyor_index
    root_path
  end

  def redirect_with_message(path, message_type, message)
    respond_to do |format|
      format.html do
        flash[message_type] = message if !message.blank? and !message_type.blank?
        redirect_to path
      end
      format.js do
        render :text => message, :status => 403
      end
    end
  end

  def create_new_response_set(attrs)
    @response_set = ResponseSet.clone_response_set(@response_set, attrs)
  end

  def switch_survey(survey)
    attrs = prepare_new_response_set
    attrs['survey_id'] = survey.id
    response_set = @response_set
    create_new_response_set(attrs)
    response_set.supersede!
  end

  def load_and_update_response_set_with_retries(remaining=2)
    begin
      load_and_update_response_set
    rescue ActiveRecord::StatementInvalid => e
      if remaining > 0
        load_and_update_response_set_with_retries(remaining - 1)
      else
        raise e
      end
    end
  end

  def load_and_update_response_set
    ResponseSet.transaction do
      @response_set = ResponseSet.
        find_by_access_code(params[:response_set_code], :include => {:responses => :answer})
      saved = true
      if params[:r]
        @response_set.update_from_ui_hash(params[:r])
      end
      if params[:finish]
        @response_set.complete!
        saved &= @response_set.save
      end
      saved
    end
  end

  ##
  # If the hidden field surveyor_javascript_enabled is set to true
  # cf. surveyor/edit.html.haml
  # the set the session variable [:surveyor_javascript] to "enabled"
  def determine_if_javascript_is_enabled
    if params[:surveyor_javascript_enabled] && params[:surveyor_javascript_enabled].to_s == "true"
      session[:surveyor_javascript] = "enabled"
    else
      session[:surveyor_javascript] = "not_enabled"
    end
  end

end
