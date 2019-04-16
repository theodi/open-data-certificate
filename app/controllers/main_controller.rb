class MainController < ApplicationController

  def ping
    if ActiveRecord::Base.connection.active?
      head :ok
    else
      head :service_unavailable
    end
  end

  def home
    respond_to do |format|
      format.html { render '/home/index' }
    end
  end

  def discussion
    @topic = 'general'
    @topic_help  = I18n.t 'general', scope: :discussions, default: ''
    render 'comment'
  end

  def git_head
    head = Rails.root.to_s.split("/").last
    render :text => head
  end

  def status
    @job_count = Delayed::Job.count
    @all = Stat.where(name: 'all').last
    @published = Stat.where(name: 'published').last
    @head_commit = Rails.root.to_s.split("/").last

    type = params[:type] || "all"

    respond_to do |format|
      format.html { render '/home/status' }
      format.csv { send_data Stat.csv(type), filename: "#{type}.csv", type: "text/csv; header=present; charset=utf-8" }
    end
  end

  def legacy_stats
    csv = Rackspace.fetch_cache("statistics.csv")
    send_data csv, filename: "legacy_stats.csv", type: "text/csv; header=present; charset=utf-8"
  end

  def status_response_sets
    @response_sets = ResponseSet.all.map do |m|
      {
        id: m.id,
        created_at: m.created_at.to_i,
        state: m.aasm_state
      }
    end

    respond_to do |format|
      format.json { render json: @response_sets.to_json  }
    end
  end

  def status_events
    @events = DevEvent.order('created_at DESC').page(params[:page]).per(100)
  end

  # A user pings this url if they have js enabled, so we can tell surveyor
  # not to find unnecessary requirements.
  def has_js
    session[:surveyor_javascript] = "enabled"
    render :text => 'ok'
  end


  # method for clearing the cache
  def clear_cache
    Rails.cache.clear
    render :text => 'cleared'
  end

  # mostly lifted from surveyor#create
  def start_questionnaire
    # bypassing the need for the user to select the survey - since we're launching with just one 'legislation'
    # When multiple legislations are available, this value will need to be provided by the form
    access_code = params[:survey_access_code] ||
                  current_user.try(:default_jurisdiction) ||
                  Survey::DEFAULT_ACCESS_CODE


    # if a dataset isn't supplied, create one for an authenticated user, or mock one for unauthenticated
    @dataset = Dataset.find_by_id(params[:dataset_id]) || (user_signed_in? ? current_user.datasets.create : Dataset.create)
    authorize! :update, @dataset

    # use the most recent survey
    @survey = Survey.newest_survey_for_access_code(access_code)

    @response_set = ResponseSet.
      create(:survey => @survey,
             :user_id => current_user.try(:id),
             :dataset_id => @dataset.id
    )

    if @survey && @response_set
      session[:response_set_id] = current_user ? nil : @response_set.id

      if params[:source_response_set_id]
        source_response_set = ResponseSet.find(params[:source_response_set_id]) # TODO: ensure user has rights to copy the response set answers?
        @response_set.copy_answers_from_response_set!(source_response_set)
      end

      # flash[:notice] = t('surveyor.survey_started_success')
      redirect_to(survey_start_path(:response_set_code => @response_set.access_code))
    else
      flash[:notice] = t('surveyor.unable_to_find_that_legislation')
      redirect_to (user_signed_in? ? dashboard_path : root_path)
    end
  end

end
