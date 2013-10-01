class TransfersController < ApplicationController

  def create
    @transfer = Transfer.new params[:transfer]
    @transfer.user = current_user

    authorize! :manage, @transfer.dataset

    if @transfer.save
      @transfer.notify!
      flash[:notice] = 'Transfer created'
    else
      flash[:error] = "Unable to create transfer #{@transfer.errors.full_messages.join ', '}"
    end

    redirect_to dashboard_path

  end

  def claim
    @transfer = Transfer.find params[:id]
  end

  def accept
    @transfer = Transfer.find params[:id]
    @transfer.assign_attributes params[:transfer]
    @transfer.target_user = current_user

    begin
      authorize! :accept, @transfer
      flash[:notice] = 'Transfer completed' if @transfer.accept!
    rescue CanCan::AccessDenied
      flash[:error] = 'Access Denied'
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
