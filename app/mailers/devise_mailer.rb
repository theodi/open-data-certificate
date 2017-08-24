class DeviseMailer < Devise::Mailer   
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  
  def confirmation_instructions(*args)
    headers['X-MC-Subaccount'] = "certificates"
    super
  end

  def reset_password_instructions(*args)
    headers['X-MC-Subaccount'] = "certificates"
    super
  end

  def unlock_instructions(*args)
    headers['X-MC-Subaccount'] = "certificates"
    super
  end

end