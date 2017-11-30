class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.integer :total_deleted_users
      t.integer :total_deleted_rentals
      t.integer :total_deleted_cars
      t.timestamps
    end
  end
end
