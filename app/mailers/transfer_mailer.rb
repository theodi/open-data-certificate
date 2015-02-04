class TransferMailer < ActionMailer::Base

  default from: Devise.mailer_sender

  def notify(transfer)
    @transfer = transfer
    mail(to: @transfer.target_email)
  end
  
end
