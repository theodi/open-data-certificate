class CertificatesController < ApplicationController
  include CertificatesHelper

  before_filter(:except => [:legacy_show, :certificate_from_dataset_url]) { get_certificate }
  before_filter(:only => [:show]) { alternate_formats [:json] }
  before_filter(:only => [:show, :badge]) { readable? }
  before_filter(:only => [:badge]) { log_embed }
  before_filter :authenticate_user!, only: :report

  helper_method :resume_path

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def legacy_show
    certificate = Certificate.find params[:id]
    case params[:type]
    when nil
      redirect_to dataset_certificate_path certificate.response_set.dataset.id, certificate.id
    when "embed"
      redirect_to embed_dataset_certificate_path certificate.response_set.dataset.id, certificate.id
    when "badge"
      redirect_to badge_dataset_certificate_path certificate.response_set.dataset.id, certificate.id, format: params[:format]
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def improvements
    @response_set = @certificate.response_set
    if @response_set

      @requirements = @response_set.outstanding_requirements
      @mandatory_fields = @response_set.incomplete_triggered_mandatory_questions

      respond_to do |format|
        format.html { render 'surveyor/requirements' }
        format.json { render :text => @response_set.outstanding_requirements.to_json, content_type: "application/json" }
      end
    else
      flash[:warning] = t('surveyor.unable_to_find_your_responses')
      redirect_to surveyor_index
    end
  end

  def progress
    render json: @certificate.response_set.progress
  end

  def embed
    respond_to do |format|
      format.html { render :show, layout: 'embedded_certificate' }
    end
  end

  def badge
    respond_to do |format|
      format.js
      format.html { render 'badge', :layout => false }
      format.png { send_data(@certificate.badge_file.read, :type => "image/png", :disposition => 'inline') }
    end
  end

  def certificate_from_dataset_url
    params[:datasetUrl] ||= request.env['HTTP_REFERER']
    dataset = Dataset.match_to_user_domain(params[:datasetUrl])
    certificate = dataset.try(:certificate)
    raise ActiveRecord::RecordNotFound unless dataset && certificate
    if params[:type].nil?
      redirect_to dataset_certificate_path certificate.response_set.dataset.id, certificate.id, format: params[:format]
    elsif params[:type] == "embed"
      redirect_to embed_dataset_certificate_path certificate.response_set.dataset.id, certificate.id, format: params[:format]
    elsif params[:type] == "badge"
      redirect_to badge_dataset_certificate_path certificate.response_set.dataset.id, certificate.id, format: params[:format]
    end
  end


  # community certification
  def verify
    if user_signed_in?
      if params[:undo]
        @certificate.verifications.where(user_id: current_user.id).first.try(:destroy)
      else
        @certificate.verifications.create user_id: current_user.id
      end
    end

    redirect_to dataset_certificate_path params.select {|d| [:dataset_id, :id].include? d}
  end

  def report
    reporter = {
      email: current_user.email,
      remote_ip: request.remote_ip,
      user_agent: request.env['HTTP_USER_AGENT']
    }
    @certificate.report!(params[:reasons], reporter)

    flash[:notice] = I18n.t('certificates.flashes.reported')
    redirect_to dataset_certificate_path(params[:dataset_id], @certificate)
  end

  # used by an admin to mark as audited
  def update
    authorize! :manage, @certificate
    @certificate.update_attribute :audited, params[:certificate] && params[:certificate][:audited]
    redirect_to dataset_certificate_path @certificate.response_set.dataset.id, @certificate.id
  end

  protected

  def resume_path(question = nil)
    continue_my_survey_path(
      response_set_code: @response_set.access_code,
      question: question.try(:id))
  end

  private

    def get_certificate
      if params[:id]
        @certificate = get_dataset.certificates.find(params[:id])
      else
        @certificate = get_dataset.certificate
      end
    end

    def get_dataset
      @dataset = Dataset.find(params[:dataset_id])
    end

    def readable?
      raise ActiveRecord::RecordNotFound unless @certificate && can?(:read, @certificate)
    end

    def log_embed
      unless request.referer =~ /https?:\/\/#{request.host_with_port}./
        get_dataset.register_embed(request.referer)
      end
    end

end
