class AddTrainingsCountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :trainings_count, :integer, default: 0

    reversible do |change|
      change.up do
        User.reset_column_information
        User.all.each do |u|
          User.update_counters u.id, trainings_count: u.users_trainings.length
        end
      end
    end
  end
end
