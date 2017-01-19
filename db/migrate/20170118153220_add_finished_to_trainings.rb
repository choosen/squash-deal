class AddFinishedToTrainings < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :finished, :boolean, null: false, default: false
  end
end
