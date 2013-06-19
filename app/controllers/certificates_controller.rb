class CertificatesController < ApplicationController
  before_filter :redirect_to_root, except: [:show, :embed, :badge] #TODO: Commented browse certificate functionality - remove this filter when browsing certificates goes back

  def index
    @search = params[:search]
    # TODO: if the search ever needs to change (adding fields, etc), it would be very sensible to slot the Ransack gem in...
    @certificates = @search ? Certificate.search(@search) : Certificate
    @certificates = @certificates.by_newest.includes(:response_set => :survey)
  end

  def show
    @certificate = Certificate.find params[:id]

    # pretend unpublished certificates don't exist
    unless @certificate.published?
      raise ActiveRecord::RecordNotFound
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
