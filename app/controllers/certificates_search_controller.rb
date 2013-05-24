class CertificatesSearchController < ApplicationController
  def new
  end

  def create
    @search = params[:search]
    # TODO: if the search ever needs to change (adding fields, etc), it would be very sensible to slot the Ransack gem in...
    @certificates = @search ? Certificate.search(@search) : Certificate
    @certificates = @certificates.by_newest.includes(:response_set => :survey)
    render '/certificates/index'
  end
end
