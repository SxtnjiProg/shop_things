class AddCategoryRefToProducts < ActiveRecord::Migration[7.1]
  def change
    # Змінили null: false на null: true
    add_reference :products, :category, null: true, foreign_key: true
  end
end