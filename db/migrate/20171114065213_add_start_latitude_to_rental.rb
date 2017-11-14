class AddStartLatitudeToRental < ActiveRecord::Migration[5.1]
  def change
    add_column :rentals, :start_latitude, :float
  end
end
