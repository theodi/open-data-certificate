class ClaimMailer < ApplicationMailer

  def notify(claim)
    @claim = claim
    if Claim::DELIVERY_ADMIN_OVERRIDE
      to = Devise.mailer_sender
      subject = I18n.t('claim_mailer.notify.admin_subject', dataset_id: @claim.dataset.id)
    else
      to = @claim.user.email
      subject = I18n.t('claim_mailer.notify.subject', title: @claim.dataset.title)
    end
    mail(to: to, subject: subject)
  end

  def notify_of_denial(claim)
    @claim = claim
    mail(to: @claim.initiating_user.email, subject: I18n.t('claim_mailer.notify_of_denial.subject', title: @claim.dataset.title))
  end

  def notify_of_approval(claim)
    @claim = claim
    mail(to: @claim.initiating_user.email, subject: I18n.t('claim_mailer.notify_of_approval.subject', title: @claim.dataset.title))
  end

end
