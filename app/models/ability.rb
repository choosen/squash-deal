# Define permissions to actions
class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    if user.admin?
      can :manage, :all
      cannot :reaction_to_invite, UsersTraining do |users_training|
        users_training.user.id != user.id
      end
    else
      define_user_priviliges(user)
    end
  end

  def define_user_priviliges(user)
    alias_action :invitation_accept, :invitation_remove, to: :reaction_to_invite

    can :read, :all
    can :manage, User, id: user.id
    can :create, Training
    can :manage, Training, owner: user
    can :update, UsersTraining, training: { owner: user }
    can :reaction_to_invite, Training
    can :reaction_to_invite, UsersTraining, user: user
  end
end
