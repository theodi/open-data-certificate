class Ability
  include CanCan::Ability

  def initialize(user)
    
    can :manage, ResponseSet, user_id: nil
    can :manage, ResponseSet, user_id: user.id

    can :manage, Dataset, user_id: nil
    can :manage, Dataset, user_id: user.id
    can :read, Dataset

  end
end
