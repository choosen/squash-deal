class AddOwnerToTraining < ActiveRecord::Migration[5.0]
  def change
    add_reference :trainings, :owner, foreign_key: { to_table: :users }
    reversible do |dir|
      dir.up { Training.all.each { |t| t.update(owner: t.users.first || User.first) }  }
    end
  end
end
