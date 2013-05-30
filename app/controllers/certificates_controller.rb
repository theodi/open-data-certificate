class CertificatesController < ApplicationController
  def index
    @search = params[:search]
    # TODO: if the search ever needs to change (adding fields, etc), it would be very sensible to slot the Ransack gem in...
    @certificates = @search ? Certificate.search(@search) : Certificate
    @certificates = @certificates.by_newest.includes(:response_set => :survey)
  end

  def show
    @certificate = Certificate.find params[:id]
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

end
