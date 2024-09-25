class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :full_name, :string
    add_column :users, :username, :string
    add_column :users, :role, :string
  end
end
