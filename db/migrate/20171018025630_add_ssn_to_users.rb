class AddSsnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ssn, :integer
  end
end
