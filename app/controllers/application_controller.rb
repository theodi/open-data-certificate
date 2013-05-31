class ApplicationController < ActionController::Base
  include Extracts::Application::ExceptionHandling

  protect_from_forgery
  before_filter :set_locale

  helper_method :after_sign_in_path_for
  
  # pick the locale from ?locale=X in the url,  a prettier
  # solution might be used down the line, maybe depending
  # on the ui or user preferences maybe.
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # maintain the locale param on any urls
  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def home
    @surveys = Survey.available_to_complete
    render '/home/index'
  end

  # mostly lifted from surveyor#create
  def start_questionnaire
    # bypassing the need for the user to select the survey - since we're launching with just one 'legislation'
    # When multiple legislations are available, this value will need to be provided by the form
    params[:survey_access_code] = Survey.available_to_complete.first.try(:access_code) if params[:survey_access_code].blank?

    # if a dataset isn't supplied, create one for an authenticated user, or mock one for unauthenticated
    @dataset = Dataset.find_by_id(params[:dataset_id]) || (user_signed_in? ? Dataset.create(user: current_user) : Dataset.new)
    authorize! :update, @dataset

    if params[:survey_access_code].blank?
      flash[:notice] = t('surveyor.please_choose_a_legislation')
      redirect_to (@dataset.persisted? ? @dataset : root_url) and return
    end

    surveys = Survey.where(:access_code => params[:survey_access_code]).order("survey_version DESC")

    # use the most recent survey for now
    @survey = surveys.first

    @response_set = ResponseSet.
      create(:survey => @survey,
             :user_id => (current_user.nil? ? current_user : current_user.id),
             :dataset_id => @dataset.id
    )

    if @survey && @response_set
      session[:response_set_id] = current_user ? nil : @response_set.id

      if params[:source_response_set_id]
        source_response_set = ResponseSet.find(params[:source_response_set_id]) # TODO: ensure user has rights to copy the response set answers?
        @response_set.copy_answers_from_response_set!(source_response_set)
      end

      flash[:notice] = t('surveyor.survey_started_success')
      redirect_to(surveyor.edit_my_survey_path(
                    :survey_code => @survey.access_code, :response_set_code => @response_set.access_code))
    else
      flash[:notice] = t('surveyor.unable_to_find_that_legislation')
      redirect_to @dataset.persisted? ? @dataset : root_url
    end
  end

  def after_sign_in_path_for(resource)
    # If the user has a survey stored in their session, assign it to them and redirect to the survey,
    # deleting the session id even if the response set isn't found
    case
      when session[:response_set_id] && response_set = ResponseSet.find(session.delete(:response_set_id))

        # Assign the response set to the user, creating a dataset for it
        response_set.assign_to_user!(current_user)

        return surveyor.edit_my_survey_path(
          :survey_code => response_set.survey.access_code,
          :response_set_code => response_set.access_code
        )


      when params[:form_id] == 'start_cert_modal_form'
        # if the user has authenticated from the start_cert_modal_form then redirect to the start_questionnaire path
        authenticated_start_questionnaire_path

      else
        dashboard_path
    end
  end

end
