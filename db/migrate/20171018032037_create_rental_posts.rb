class CreateRentalPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :rental_posts do |t|
      t.integer :car_id
      t.integer :owner_id
      t.integer :renter_id
      t.string :start_location
      t.string :end_location
      t.datetime :start_time
      t.datetime :end_time
      t.float :price

      t.timestamps
    end
  end
end
