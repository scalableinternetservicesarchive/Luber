class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :isadmin
      t.integer :ssn

      t.timestamps
    end
  end
end
