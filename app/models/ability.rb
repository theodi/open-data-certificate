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

    can :read, Dataset

  end
end
