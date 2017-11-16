class AddStartLongitudeToRental < ActiveRecord::Migration[5.1]
  def change
    add_column :rentals, :start_longitude, :float
  end
end
