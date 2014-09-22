class CertificatesController < ApplicationController
  include CertificatesHelper

  before_filter(:except => [:latest, :legacy_show, :certificate_from_dataset_url]) { get_certificate }
  before_filter(:only => [:show]) { alternate_formats [:json] }
  before_filter(:only => [:badge]) { log_embed }

  def show
    # pretend unpublished certificates don't exist
    unless @certificate.published?

      # but not if the current user owns them
      unless current_user && current_user == @certificate.user
        raise ActiveRecord::RecordNotFound
      end
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def latest
    certificate = Dataset.find(params[:dataset_id]).certificates.latest
    unless certificate.nil?
      if params[:type].nil?
        redirect_to dataset_certificate_path params[:dataset_id], certificate.id, format: params[:format]
      elsif params[:type] == "embed"
        redirect_to embed_dataset_certificate_path params[:dataset_id], certificate.id, format: params[:format]
      elsif params[:type] == "badge"
        redirect_to badge_dataset_certificate_path params[:dataset_id], certificate.id, format: params[:format]
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def legacy_show
    certificate = Certificate.find params[:id]
    if params[:type].nil?
      redirect_to dataset_certificate_path certificate.response_set.dataset.id, certificate.id
    elsif params[:type] == "embed"
      redirect_to embed_dataset_certificate_path certificate.response_set.dataset.id, certificate.id
    elsif params[:type] == "badge"
      redirect_to badge_dataset_certificate_path certificate.response_set.dataset.id, certificate.id, format: params[:format]
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

  # this is similiar to the improvements, but returns
  # json only, and includes completed questions too
  def progress
    @progress = @certificate.progress

    render json: @progress
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
    certificate = dataset.certificates.latest
    unless certificate.nil?
      if params[:type].nil?
        redirect_to dataset_certificate_path certificate.response_set.dataset.id, certificate.id, format: params[:format]
      elsif params[:type] == "embed"
        redirect_to embed_dataset_certificate_path certificate.response_set.dataset.id, certificate.id, format: params[:format]
      elsif params[:type] == "badge"
        redirect_to badge_dataset_certificate_path certificate.response_set.dataset.id, certificate.id, format: params[:format]
      end
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

  # used by an admin to mark as audited
  def update
    authorize! :manage, @certificate
    @certificate.update_attribute :audited, params[:certificate] && params[:certificate][:audited]
    redirect_to dataset_certificate_path @certificate.response_set.dataset.id, @certificate.id
  end

  private

    def get_certificate
      @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])
    end

    def log_embed
      unless request.referer =~ /https?:\/\/#{request.host_with_port}./
        @certificate.dataset.register_embed(request.referer)
      end
    end

end
