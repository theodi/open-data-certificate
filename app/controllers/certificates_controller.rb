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
end
