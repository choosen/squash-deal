# Define permissions to actions
class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :invitation_accept, :invitation_remove, to: :reaction_to_invite

    return unless user

    if user.admin?
      define_admin_priviliges(user)
    else
      define_user_priviliges(user)
    end
    cannot :invite, Training, done?: true
  end

  def define_admin_priviliges(user)
    can :manage, :all
    cannot :reaction_to_invite, UsersTraining do |users_training|
      users_training.user_id != user.id
    end
    cannot :update, UsersTraining, training: { done?: false }
    can :update, UsersTraining, user_id: user.id
  end

  def define_user_priviliges(user)
    can :read, :all
    can :manage, User, id: user.id
    can :create, Training
    can :manage, Training, owner_id: user.id
    can :update, UsersTraining, training: { owner_id: user.id, done?: true }
    can :update, UsersTraining, user_id: user.id, training: { done?: false }
    can :reaction_to_invite, Training, done?: false
    can :reaction_to_invite, UsersTraining, user_id: user.id, accepted_at: nil,
                                            training: { done?: false }
  end
end
