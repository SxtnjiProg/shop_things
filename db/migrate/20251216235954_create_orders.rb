# db/migrate/[timestamp]_create_orders.rb

class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'pending', null: false # Нове замовлення
      t.decimal :total_price, precision: 10, scale: 2, null: false

      # Адреса доставки
      t.string :street, null: false
      t.string :city, null: false
      t.string :zip_code
      t.string :country, default: 'Ukraine'

      t.timestamps
    end
    add_index :orders, :status
  end
end