class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.integer :action
      t.string :content
      t.timestamps
    end
  end
end
