class AddColumnsToRentalPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :rental_posts, :start_latitude, :float
    add_column :rental_posts, :start_longitude, :float
  end
end
