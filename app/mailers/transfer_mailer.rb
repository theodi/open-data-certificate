class TransferMailer < ApplicationMailer

  def notify(transfer)
    @transfer = transfer
    mail(to: @transfer.target_email)
  end
  
end
