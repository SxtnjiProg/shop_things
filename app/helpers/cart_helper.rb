# app/helpers/cart_helper.rb

module CartHelper
  
  # Отримує деталі кошика: Product-об'єкт, кількість, проміжна_сума
  # Використовується в Cart#index, Orders#new та Orders#create
  def cart_items_with_products
    # Якщо кошик у сесії порожній або не існує, повертаємо порожній масив
    cart_data = session[:cart] || {}
    return [] if cart_data.empty?

    # 1. Отримуємо ID товарів, які є в кошику
    product_ids = cart_data.keys.map(&:to_s)
    
    # 2. Одночасно завантажуємо всі об'єкти Product з бази даних
    # index_by(&:id) допомагає створити хеш, де ключ — це ID товару, для швидкого пошуку.
    products = Product.where(id: product_ids).index_by { |p| p.id.to_s }

    # 3. Формуємо остаточний масив даних для відображення
    cart_data.map do |product_id_str, quantity|
      product = products[product_id_str]
      
      # Якщо товар не знайдено (наприклад, був видалений з БД), пропускаємо його
      next unless product 

      subtotal = product.price * quantity
      
      {
        product: product,
        quantity: quantity,
        subtotal: subtotal
      }
    end.compact # compact видаляє всі nil-значення, якщо якісь товари були пропущені
  end

  # Обчислює загальну вартість товарів у кошику (без урахування доставки)
  def total_cart_price
    cart_items_with_products.sum { |item| item[:subtotal] }
  end
end