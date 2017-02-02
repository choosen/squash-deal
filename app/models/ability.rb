# Define permissions to actions
class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :manage, User, id: user.id
      can :create, Training
      can :manage, Training, owner: user
    end
  end
end
