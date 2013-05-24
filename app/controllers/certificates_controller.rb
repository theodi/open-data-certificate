class CertificatesController < ApplicationController
  def index
    @certificates = Certificate.all
  end

  def show
    @certificate = Certificate.find params[:id]
  end
end
