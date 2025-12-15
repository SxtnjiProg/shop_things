class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.string :category
      t.string :image
      t.integer :stock

      t.timestamps
    end
  end
end
