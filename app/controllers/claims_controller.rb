class ClaimsController < ApplicationController
  before_filter :authenticate_user!

  def create
    dataset = Dataset.find(claim_data[:dataset_id])
    certificate = dataset.certificate
    authorize! :claim, certificate
    claim = current_user.sent_claims.create!(:dataset => dataset)
    flash[:notice] = I18n.t('claims.flashes.created')
    claim.notify!
    redirect_to dataset_certificate_path(dataset.id, certificate)
  end

  def index
    claims = if current_user.admin?
      Claim.outstanding
    else
      current_user.received_claims
    end
    @outstanding_claims = claims.outstanding.page params[:page]
  end

  def approve
    claim = Claim.find(params[:id])
    authorize! :manage, claim
    claim.accept
    claim.save
    respond_to do |format|
      format.html { redirect_to claims_path }
      format.js { render json: { message: I18n.t('claims.approved') } }
    end
  end

  def deny
    claim = Claim.find(params[:id])
    authorize! :manage, claim
    claim.deny
    claim.save
    respond_to do |format|
      format.html { redirect_to claims_path }
      format.js { render json: { message: I18n.t('claims.denied') } }
    end
  end

  protected
  def claim_data
    params[:claim]
  end
end
