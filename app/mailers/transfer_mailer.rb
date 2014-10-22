class TransferMailer < ActionMailer::Base

  default from: Devise.mailer_sender

  def notify(transfer_id)
    if @transfer = Transfer.find(transfer_id)
      mail(to: @transfer.target_email)
    end
  end
  
end
