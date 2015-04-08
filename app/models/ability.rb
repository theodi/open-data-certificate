class Ability
  include CanCan::Ability

  def initialize(user)
    
    can :manage, ResponseSet do |response_set|
      response_set.nil? ||
        (
        response_set.user.nil? ||
        response_set.user == user
        )
    end
    
    can :read, Dataset do |dataset|
      dataset.visible? || user.try(:admin?) || dataset.owned_by?(user)
    end

    can :manage, Dataset do |dataset|
      dataset.user.nil? || dataset.owned_by?(user)
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
      user.admin? || claim.try(:user) == user
    end

    can :destroy, Transfer, user: user

    can :read, CertificateGenerator do |generator|
      generator.try(:user) == user
    end

    can :read, CertificationCampaign do |campaign|
      campaign.try(:user) == user
    end

    can :read, Certificate do |certificate|
      certificate.visible? || owns(user, certificate)
    end

    can :manage, Certificate do |certificate|
      owns(user, certificate)
    end

  end

  def owns(user, model)
    model.user.present? && model.user == user
  end
end
