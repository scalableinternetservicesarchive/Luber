class CreateRentalPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :rental_posts do |t|
      t.integer :car_id, foreign_key: true
      t.integer :owner_id, foreign_key: true
      t.integer :renter_id, foreign_key: true
      t.string :start_location
      t.string :end_location
      t.datetime :start_time
      t.datetime :end_time
      t.float :price

      t.timestamps
    end
    add_index :rental_posts, [:owner_id, :created_at]
  end
end
