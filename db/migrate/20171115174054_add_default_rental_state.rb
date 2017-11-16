class AddDefaultRentalState < ActiveRecord::Migration[5.1]

  def up
    change_column :rentals, :status, :integer, default: 0
  end

  def down
    change_column :rentals, :status, :integer, default: nil
  end

end
