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
    
    can :manage, Dataset do |dataset|
      dataset.user.nil? ||
        dataset.user == user
    end

    if user.try(:admin?)
      can :manage, :all
    end

    can :read, Dataset

    can :accept, Transfer do |transfer|
      transfer.has_target_user? &&
      transfer.token_match? &&
      transfer.target_email_match? &&
      !transfer.target_email_changed?
    end

    can :destroy, Transfer, user: user

  end
end
