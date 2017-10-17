class CreateRentalPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :rental_posts do |t|
      t.integer :car
      t.integer :owner
      t.integer :renter
      t.string :start_loc
      t.string :end_loc
      t.datetime :start_time
      t.datetime :end_time
      t.float :cost

      t.timestamps
    end
  end
end
