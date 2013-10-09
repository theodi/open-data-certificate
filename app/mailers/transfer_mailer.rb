class TransferMailer < ActionMailer::Base

  default from: Devise.mailer_sender

  # notify the target user
  def notify transfer
    @transfer = transfer
    mail(to: @transfer.target_email)
  end
  
end
