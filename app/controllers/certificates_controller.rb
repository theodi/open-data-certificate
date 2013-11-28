class CertificatesController < ApplicationController
  include CertificatesHelper
  
  before_filter(:only => [:show]) { alternate_formats [:json] }

  def show
    @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])

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
      redirect_to badge_dataset_certificate_path certificate.response_set.dataset.id, certificate.id
    end
  end

  def improvements
    @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])
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
    @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])
    @response_set = @certificate.response_set

    # requirements still to be met
    outstanding = @response_set.triggered_requirements.map do |r|
      r.reference_identifier
    end

    # questions that have been answered and their requirements
    entered = @response_set.responses.map(&:answer).map do |a|
      a.requirement.try(:scan, /\S+_\d+/) #if a.question.triggered? @response_set
    end

    # the counts of mandatory questions and completions
    mandatory = @response_set.incomplete_triggered_mandatory_questions.count
    mandatory_completed = @response_set.responses.map(&:question).select(&:is_mandatory).count


    @responses = {
      outstanding: outstanding.sort,
      entered: entered.flatten.compact.sort,

      # counts only
      mandatory: mandatory,
      mandatory_completed: mandatory_completed
    }

    render json: @responses
  end

  def embed
    @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])
    respond_to do |format|
      format.html { render :show, layout: 'embedded_certificate' }
    end
  end

  def badge
    @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])
    respond_to do |format|
      format.js
      format.html { render 'badge', :layout => false }
      format.png { send_data(@certificate.badge_file.read, :type => "image/png", :disposition => 'inline') }
    end
  end
  
  def certificate_from_dataset_url
    params[:datasetUrl] ||= request.env['HTTP_REFERER']
    datasets = Dataset.where(:documentation_url => params[:datasetUrl])
    if datasets.count > 1
      # Try and find the dataset where the user's email domain matches the documentation_url
      dataset = datasets.select { |d| Domainatrix.parse(d.documentation_url).domain == Domainatrix.parse(d.user.email).domain }.first
            
      # If not, just default to first
      if dataset.nil?
        dataset = datasets.first
      end
    else
      dataset = datasets.first
    end
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
    @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])

    if user_signed_in?
      if params[:undo]
        @certificate.verifications.where(user_id: current_user.id).first.try(:destroy)
      else
        @certificate.verifications.create user_id: current_user.id
      end
    end

    redirect_to dataset_certificate_path params.select {|d| [:dataset_id, :id].include? d}
  end


end
