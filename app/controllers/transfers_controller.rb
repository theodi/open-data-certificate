
class TransfersController < ApplicationController

  def create
    @transfer = Transfer.new params[:transfer]
    @transfer.user = current_user

    authorize! :manage, @transfer.dataset

    if @transfer.save
      @transfer.notify!
      flash[:notice] = t('transfers.flashes.created')
    else
      flash[:error] = t('transfers.flashes.unable_to_create', errors: @transfer.errors.full_messages.join(', '))
    end

    redirect_to dashboard_path

  end

  def claim
    @transfer = Transfer.find params[:id]
    session[:sign_in_redirect] = request.original_fullpath unless user_signed_in? 
  end

  def accept
    @transfer = Transfer.find params[:id]
    @transfer.assign_attributes params[:transfer]
    @transfer.target_user = current_user

    begin
      authorize! :accept, @transfer
      flash[:notice] = t('transfers.flashes.complete') if @transfer.accept!
    rescue CanCan::AccessDenied
      flash[:error] =
        if !@transfer.token_match?
          t('transfers.flashes.access_denied_token')
        elsif !@transfer.target_email_match?
          t('transfers.flashes.access_denied_email')
        else
          t('transfers.flashes.access_denied')
        end
          
    end

    redirect_to dashboard_path
  end

  def destroy 
    @transfer = Transfer.find params[:id]

    begin
      authorize! :destroy, @transfer
      @transfer.destroy
    rescue CanCan::AccessDenied
      flash[:error] = 'Access Denied'
    end

    redirect_to dashboard_path
    
  end
end
