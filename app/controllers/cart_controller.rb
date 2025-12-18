class CartController < ApplicationController
  before_action :authenticate_user! # Захист: тільки для авторизованих

  def index
    @cart = session[:cart] || {}
    @cart_items = []
    @total = 0

    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product  # Якщо товар видалено

      subtotal = product.price * quantity
      @total += subtotal
      @cart_items << { product: product, quantity: quantity, subtotal: subtotal }
    end
  end

  def add
    id = params[:id].to_i
    product = Product.find(id)

    if product.stock > 0
      session[:cart] ||= {}
      session[:cart][id] = (session[:cart][id] || 0) + 1
      redirect_to products_path, notice: "#{product.name} додано в кошик!"
    else
      redirect_to products_path, alert: 'Товар недоступний (sold out)'
    end
  end

  def update_quantity
    id = params[:id].to_i
    quantity = params[:quantity].to_i

    if quantity <= 0
      session[:cart].delete(id.to_s)
    else
      session[:cart][id.to_s] = quantity
    end

    redirect_to cart_index_path, notice: 'Кошик оновлено'
  end

  def clear
    session[:cart] = {}
    redirect_to cart_index_path, notice: 'Кошик очищено'
  end

  # --- НОВА ЛОГІКА ОФОРМЛЕННЯ (CHECKOUT) ---

  # 1. Показ форми для введення адреси
  def checkout_form
    if session[:cart].blank?
      redirect_to cart_index_path, alert: "Ваш кошик порожній!"
    else
      @order = Order.new # Створюємо пустий об'єкт для форми
    end
  end

  # 2. Обробка форми та створення замовлення
  def create_order
    # Рахуємо загальну суму товарів у кошику
    products = Product.find(session[:cart].keys)
    total_price = 0
    products.each do |product|
      qty = session[:cart][product.id.to_s].to_i
      total_price += product.price * qty
    end

    # Створюємо замовлення з даними адреси з форми
    @order = current_user.orders.build(order_params)
    @order.total_price = total_price
    @order.status = 'pending' 

    if @order.save
      # Якщо замовлення збереглось, переносимо товари з кошика в базу
      products.each do |product|
        qty = session[:cart][product.id.to_s].to_i
        @order.order_items.create(
          product: product,
          quantity: qty,
          price: product.price
        )
      end

      # Очищаємо кошик
      session[:cart] = {}

      # Перенаправляємо на профіль (вкладка orders)
      redirect_to profile_path(tab: 'orders'), notice: "Дякуємо! Замовлення №#{@order.id} успішно створено."
    else
      # Якщо помилка валідації (наприклад, пуста адреса), показуємо форму знову
      render :checkout_form, status: :unprocessable_entity
    end
  end

  private

  # Дозволяємо тільки поля адреси
  def order_params
    params.require(:order).permit(:street, :city, :country, :zip_code)
  end
end