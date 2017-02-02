class AddMultisportUsedToUsersTrainings < ActiveRecord::Migration[5.0]
  def change
    add_column :users_trainings, :multisport_used, :boolean,
      null: false, default: false
  end
end
