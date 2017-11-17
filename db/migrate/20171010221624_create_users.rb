class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :state
      t.string :username
      t.string :email
      t.string :password_digest
      t.boolean :admin
      t.datetime :logged_in_at
      t.datetime :logged_out_at
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
