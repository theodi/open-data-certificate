class CertificatesController < ApplicationController
  def index
    @certificates = Certificate.all
  end

  def show
    @certificate = Certificate.find params[:id]
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
