class CertificatesController < ApplicationController
  before_filter :redirect_to_root, except: [:show, :update, :embed, :badge, :legacy_show, :latest, :improvements] #TODO: Commented browse certificate functionality - remove this filter when browsing certificates goes back

  def index
    @search = params[:search]
    # TODO: if the search ever needs to change (adding fields, etc), it would be very sensible to slot the Ransack gem in...
    @certificates = @search ? Certificate.search(@search) : Certificate
    @certificates = @certificates.by_newest.includes(:response_set => :survey)
  end

  def show
    @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])
    
    # pretend unpublished certificates don't exist
    unless @certificate.published?

      # but not if the current user owns them
      unless current_user && current_user == @certificate.user
        raise ActiveRecord::RecordNotFound
      end
    end
  end
  
  def latest
    certificate = Dataset.find(params[:dataset_id]).certificates.latest
    unless certificate.nil?
      if params[:type].nil?
        redirect_to dataset_certificate_path params[:dataset_id], certificate.id
      elsif params[:type] == "embed"
        redirect_to embed_dataset_certificate_path params[:dataset_id], certificate.id
      elsif params[:type] == "badge"
        redirect_to badge_dataset_certificate_path params[:dataset_id], certificate.id
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
        format.html do
          render 'surveyor/requirements'
        end
        format.json { @response_set.outstanding_requirements.to_json }
      end
    else
      flash[:warning] = t('surveyor.unable_to_find_your_responses')
      redirect_to surveyor_index
    end
  end

  def create
    # placeholder to handle searching as a POST from the index page
    index
    render action: 'index'
  end

  def embed
    @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])
    render layout: 'embedded_certificate'
  end

  def badge
    send_data(@certificate.badge_file.read, :type => "image/png", :disposition => 'inline')
    @certificate = Dataset.find(params[:dataset_id]).certificates.find(params[:id])
  end

  private
  def redirect_to_root
    #TODO: Commented browse certificate functionality - remove this method when browsing certificates goes back
    redirect_to root_url
  end

end
