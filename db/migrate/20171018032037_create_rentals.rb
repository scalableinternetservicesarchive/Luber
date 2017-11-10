class CreateRentals < ActiveRecord::Migration[5.0]
  def change
    create_table :rentals do |t|
      t.integer :owner_id
      t.integer :renter_id
      t.integer :car_id
      t.string :start_location
      t.string :end_location
      t.datetime :start_time
      t.datetime :end_time
      t.float :price
      t.integer :status
      t.string :terms
      t.timestamps
    end
  end
end
