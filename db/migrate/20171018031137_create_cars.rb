class CreateCars < ActiveRecord::Migration[5.0]
  def change
    create_table :cars do |t|
      t.integer :user_id
      t.string :plate_num
      t.string :model
      t.string :color
      t.integer :year

      t.timestamps
    end
  end
end
