class ChangePriceTypeInRentals < ActiveRecord::Migration[5.1]
  def change
    change_column :rentals, :price, :text
  end
end
