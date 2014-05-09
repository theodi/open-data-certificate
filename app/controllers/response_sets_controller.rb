# Trying out having a separate controller from the central surveyor one.
class ResponseSetsController < ApplicationController

  load_and_authorize_resource

  def destroy
    @response_set.destroy
    redirect_to dashboard_path, notice: t('dashboard.deleted_response_set')
  end

  def publish
    begin
      @response_set.publish!
      redirect_to dashboard_path, notice: t('dashboard.published_response_set')
    rescue AASM::InvalidTransition
      redirect_to dashboard_path, alert: t('dashboard.unable_to_publish_response_set_invalid')
    end
  end

  def resolve_url(url)
    if url =~ /^#{URI::regexp}$/
      HTTParty.get(url).code rescue nil
    end
  end

  def resolve
    if code = resolve_url(params[:url])
      Rails.cache.write(params[:url], code)
      render json: {status: code}
    else
      render :nothing => true
    end
  end

  # Check the user's documentation url and populate answers from it
  def start

    url = params[:response_set][:documentation_url]

    code = resolve_url(url)
    if code != 200
      return redirect_to(surveyor.edit_my_survey_path(
        :survey_code => @response_set.survey.access_code,
        :response_set_code => @response_set.access_code
      ))
    end

    kitten_data = KittenData.create(url: url, response_set: @response_set)
    kitten_data.request_data
    kitten_data.save

    @response_set.update_attribute('kitten_data', kitten_data)
    @response_set.responses.update_all(autocompleted: false)

    responses = []
    kitten_data.fields.each do |key, value|
      question = @response_set.survey.question(key)
      response = @response_set.response(key)

      next if value.nil?

      if question.type == :none || question.type == :repeater
        responses.push(HashWithIndifferentAccess.new(
          question_id: question.id.to_s,
          api_id: response ? response.api_id : Surveyor::Common.generate_api_id,
          answer_id: question.answers.first.id.to_s,
          string_value: value,
          autocompleted: true
        ))
      end

      if question.type == :one
        responses.push(HashWithIndifferentAccess.new(
          question_id: question.id.to_s,
          api_id: response ? response.api_id : Surveyor::Common.generate_api_id,
          answer_id: question.answer(value).id.to_s,
          autocompleted: true
        ))
      end

      if question.type == :any
        value.each do |item|
          responses.push(HashWithIndifferentAccess.new(
            question_id: question.id.to_s,
            api_id: response ? response.api_id : Surveyor::Common.generate_api_id,
            answer_id: question.answer(item).id.to_s,
            autocompleted: true
          ))
        end
      end
    end

    question = @response_set.survey.documentation_url
    response = @response_set.documentation_url

    responses.push(HashWithIndifferentAccess.new(
      question_id: question.id.to_s,
      answer_id: question.answers.first.id,
      string_value: url,
      api_id: response ? response.api_id : Surveyor::Common.generate_api_id,
    ))

    @response_set.update_from_ui_hash(Hash[responses.map.with_index { |value, i| [i.to_s, value] }])

    redirect_to(surveyor.edit_my_survey_path(
      :survey_code => @response_set.survey.access_code,
      :response_set_code => @response_set.access_code
    ))
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboard_path, alert: t('dashboard.unable_to_access_response_set')
  end

end
