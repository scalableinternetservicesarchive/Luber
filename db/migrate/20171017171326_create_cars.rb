class CreateCars < ActiveRecord::Migration[5.0]
  def change
    create_table :cars do |t|
      t.integer :owner
      t.string :license_plate
      t.string :model
      t.string :color
      t.integer :year
      t.integer :condition

      t.timestamps
    end
  end
end
