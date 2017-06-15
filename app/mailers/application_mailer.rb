class ApplicationMailer < ActionMailer::Base
  
  default from: Devise.mailer_sender

  def mail(*args)
    headers['X-MC-Subaccount'] = "certificates"
    super
  end

end
