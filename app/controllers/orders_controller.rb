class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_cart_presence, only: [:new, :create]
  before_action :check_admin, only: [:update]

  include CartHelper

  # ==========================================
  # ЕТАП 1: ОФОРМЛЕННЯ
  # ==========================================

  def new
    @order = current_user.orders.new
    @cart_items = cart_items_with_products
    @total_price = total_cart_price
    @shipping_cost = 0

    last_order = current_user.orders.last
    if last_order
      @order.street   = last_order.street
      @order.city     = last_order.city
      @order.zip_code = last_order.zip_code
      @order.country  = last_order.country
    end
  end

  def create
    @total_price = total_cart_price
    @shipping_cost = 0
    final_total = @total_price + @shipping_cost

    @order = current_user.orders.new(order_params)
    @order.total_price = final_total
    @order.status = 'pending'

    if @order.save
      create_order_items(@order)
      redirect_to payment_order_path(@order)
    else
      @cart_items = cart_items_with_products
      render :new, status: :unprocessable_entity
    end
  end

  # ==========================================
  # ЕТАП 2: ОПЛАТА
  # ==========================================

  def payment
    @order = current_user.orders.find(params[:id])

    if @order.status != 'pending'
      redirect_to profile_path, notice: 'Замовлення вже оброблене.'
    end
  end

  def process_payment
    @order = current_user.orders.find(params[:id])

    if @order.update(status: 'paid')
      session[:cart] = nil
      redirect_to order_path(@order), notice: 'Оплата успішна!'
    else
      redirect_to payment_order_path(@order), alert: 'Помилка оплати.'
    end
  end

  # ==========================================
  # ПЕРЕГЛЯД
  # ==========================================

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.admin? ? Order.find(params[:id]) : current_user.orders.find(params[:id])
  end

  # ==========================================
  # АДМІН
  # ==========================================

  def update
    @order = Order.find(params[:id])

    if @order.update(status: params[:order][:status])
      redirect_to profile_path, notice: 'Статус оновлено.'
    else
      redirect_to profile_path, alert: 'Помилка.'
    end
  end

  private

  def check_cart_presence
    if session[:cart].blank? || total_cart_price.zero?
      redirect_to cart_index_path, alert: 'Ваш кошик порожній.'
    end
  end

  def check_admin
    redirect_to root_path, alert: 'Доступ заборонено' unless current_user.admin?
  end

  def order_params
    params.require(:order).permit(
      :street, :city, :zip_code, :country,
      :delivery_method, :first_name, :last_name, :phone, :email
    )
  end

  def create_order_items(order)
    cart_items_with_products.each do |item|
      order.order_items.create!(
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price
      )
    end
  end
end
