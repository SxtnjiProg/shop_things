class AddMultipleImagesToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :image_2, :string
    add_column :products, :image_3, :string
    add_column :products, :image_4, :string
  end
end
