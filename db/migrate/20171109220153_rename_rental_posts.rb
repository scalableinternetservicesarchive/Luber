class RenameRentalPosts < ActiveRecord::Migration[5.1]
  def change
    rename_table :rental_posts, :rentals
  end
end
