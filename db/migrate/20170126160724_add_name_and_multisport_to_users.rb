class AddNameAndMultisportToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :multisport, :boolean, null: false, default: false
  end
end
