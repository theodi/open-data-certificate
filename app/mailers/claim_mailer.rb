class ClaimMailer < ActionMailer::Base

  default from: Devise.mailer_sender

  def notify(claim_id)
    if @claim = Claim.find(claim_id)
      mail(to: @claim.user.email)
    end
  end

  def notify_of_denial(claim_id)
    if @claim = Claim.find(claim_id)
      mail(to: @claim.initiating_user.email)
    end
  end

end
