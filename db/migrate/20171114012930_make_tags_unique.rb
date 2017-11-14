class MakeTagsUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :taggings, [:car_id, :tag_id], unique: true
  end
end
