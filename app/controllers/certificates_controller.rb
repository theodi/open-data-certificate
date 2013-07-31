class CertificatesController < ApplicationController

  def index
    @certificates = Certificate.where(:published => true)
  end

  def show
    @certificate = Certificate.find params[:id]

    # pretend unpublished certificates don't exist
    unless @certificate.published?

      # but not if the current user owns them
      unless current_user && current_user == @certificate.user
        raise ActiveRecord::RecordNotFound
      end
    end
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
