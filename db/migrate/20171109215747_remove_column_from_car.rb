class RemoveColumnFromCar < ActiveRecord::Migration[5.1]
  def change
    remove_column :cars, :plate_num, :string
  end
end
