class AddIsadminToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :isadmin, :boolean
  end
end
