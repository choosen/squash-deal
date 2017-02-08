class SetAttendedDefaultTrueToUsersTrainings < ActiveRecord::Migration[5.0]
  def change
    change_column :users_trainings, :attended, :boolean, null: false,
                                                         default: true
  end
end
