class CreateRentals < ActiveRecord::Migration[5.0]
  def change
    create_table :rentals do |t|
      t.integer :user_id
      t.integer :renter_id
      t.boolean :renter_visible, default: true
      t.integer :car_id
      t.integer :status, default: 0
      t.string :start_location
      t.float :start_longitude
      t.float :start_latitude
      t.string :end_location
      t.float :end_longitude
      t.float :end_latitude
      t.datetime :start_time
      t.datetime :end_time
      t.text :price
      t.string :terms
      t.timestamps
    end
  end
end
