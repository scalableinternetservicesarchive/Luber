class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :logged_in_at, :datetime
    add_column :users, :logged_out_at, :datetime
  end
end
