class AddColumnToCar < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :plate_number, :string
    add_column :cars, :make, :string
  end
end
