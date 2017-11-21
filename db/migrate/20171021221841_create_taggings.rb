class CreateTaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :taggings do |t|
      t.belongs_to :car, foreign_key: true
      t.belongs_to :tag, foreign_key: true
      t.timestamps
    end
    add_index :taggings, [:car_id, :tag_id], unique: true
  end
end
