class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, ResponseSet do |response_set|
      response_set.nil? || response_set.unowned_or_by?(user)
    end

    can :read, Dataset do |dataset|
      dataset.visible? || user.try(:admin?) || dataset.owned_by?(user)
    end

    can :manage, Dataset do |dataset|
      dataset.unowned_or_by?(user)
    end

    can :claim, Certificate do |certificate|
      certificate.auto_generated?
    end

    if user.try(:admin?)
      can :manage, :all
    end

    can :accept, Transfer do |transfer|
      transfer.has_target_user? &&
      transfer.token_match? &&
      transfer.target_email_match? &&
      !transfer.target_email_changed?
    end

    can :manage, Claim do |claim|
      user.admin? || claim.owned_by?(user)
    end

    can :destroy, Transfer, user: user

    can :manage, CertificateGenerator do |generator|
      generator.owned_by?(user)
    end

    can :manage, CertificationCampaign do |campaign|
      campaign.owned_by?(user)
    end

    can :read, Certificate do |certificate|
      certificate.visible? || certificate.owned_by?(user)
    end

    can :manage, Certificate do |certificate|
      certificate.owned_by?(user)
    end

  end
end
