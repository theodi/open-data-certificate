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
    if params[:token] == @transfer.token
      @transfer.target_user = current_user
      @transfer.accept!
    end
    redirect_to dashboard_path
  end

  def destroy 
    @transfer = Transfer.find params[:id]

    ## wrong
    authorize! :manage, @transfer.dataset

    @transfer.destroy

    redirect_to dashboard_path
    
  end
end
