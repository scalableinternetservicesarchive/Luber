class AddTermsToRentalPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :rental_posts, :terms, :string
  end
end
