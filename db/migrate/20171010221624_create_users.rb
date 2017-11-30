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
      t.boolean :admin, default: false
      t.integer :deleted_owner_rentals, default: 0
      t.integer :deleted_renter_rentals, default: 0
      t.datetime :signed_in_at
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
