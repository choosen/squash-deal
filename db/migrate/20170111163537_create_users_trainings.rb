class CreateUsersTrainings < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :trainings, table_name: :users_trainings do |t|
      t.index :user_id
      t.index :training_id
      t.boolean :attended, null: true
      t.timestamps
    end
    add_index :users_trainings, [:user_id, :training_id], :unique => true
  end
end
