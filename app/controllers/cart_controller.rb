class CartController < ApplicationController
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

    redirect_to cart_path, notice: 'Кошик оновлено'
  end

  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: 'Кошик очищено'
  end
end