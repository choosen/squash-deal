class CreateTrainings < ActiveRecord::Migration[5.0]
  def change
    create_table :trainings do |t|
      t.datetime :date, null: false
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
