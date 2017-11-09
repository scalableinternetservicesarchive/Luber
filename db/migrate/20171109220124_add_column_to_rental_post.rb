class AddColumnToRentalPost < ActiveRecord::Migration[5.1]
  def change
    add_column :rental_posts, :status, :integer
  end
end
