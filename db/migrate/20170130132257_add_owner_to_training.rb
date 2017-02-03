class AddOwnerToTraining < ActiveRecord::Migration[5.0]
  class Training < ActiveRecord::Base
    has_many :users, through: :users_trainings
    has_many :users_trainings
    belongs_to :owner, class_name: 'User'
  end

  class UsersTraining < ActiveRecord::Base
    self.primary_keys = :user_id, :training_id
    belongs_to :user
    belongs_to :training
  end

  class User < ActiveRecord::Base
  end

  def change
    add_reference :trainings, :owner, foreign_key: { to_table: :users }
    reversible do |dir| # Set first traiing user as default owner
      dir.up { Training.all.each { |t| t.update(owner: t.users.first || User.first) }  }
    end
  end
end
