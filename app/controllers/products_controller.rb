class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.order(created_at: :desc)  # Завантажуємо відгуки (найновіші зверху)
  end
end