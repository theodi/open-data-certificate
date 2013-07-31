class CertificatesController < ApplicationController
  before_filter :redirect_to_root, except: [:show, :update, :embed, :badge, :legacy_show, :latest] #TODO: Commented browse certificate functionality - remove this filter when browsing certificates goes back

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
    if params[:type].nil?
      redirect_to dataset_certificate_path params[:dataset_id], certificate.id
    elsif params[:type] == "embed"
      redirect_to embed_dataset_certificate_path params[:dataset_id], certificate.id
    elsif params[:type] == "badge"
      redirect_to badge_dataset_certificate_path params[:dataset_id], certificate.id
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

  def create
    # placeholder to handle searching as a POST from the index page
    index
    render action: 'index'
  end

  def embed
    @certificate = Certificate.find params[:id]
    render layout: 'embedded_certificate'
  end

  def badge
    @certificate = Certificate.find params[:id]
    send_data(@certificate.badge_file.read, :type => "image/png", :disposition => 'inline')
  end

  private
  def redirect_to_root
    #TODO: Commented browse certificate functionality - remove this method when browsing certificates goes back
    redirect_to root_url
  end

end
