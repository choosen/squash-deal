class AddAcceptedAtToUsersTrainings < ActiveRecord::Migration[5.0]
  def change
    add_column :users_trainings, :accepted_at, :datetime, null: true
    change_column :users_trainings, :attended, :boolean, null: false,
                                                         default: false
  end
end
