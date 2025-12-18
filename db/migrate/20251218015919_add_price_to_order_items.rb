class AddPriceToOrderItems < ActiveRecord::Migration[7.1]
  def change
    # Додаємо precision: 10, scale: 2 для правильного зберігання грошей
    add_column :order_items, :price, :decimal, precision: 10, scale: 2
  end
end