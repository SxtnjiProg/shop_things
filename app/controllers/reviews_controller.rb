class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: 'Відгук додано!'
    else
      redirect_to @product, alert: 'Помилка: ' + @review.errors.full_messages.join(', ')
    end
  end

  def edit
    # @review і @product вже встановлені в before_action
  end

  def update
    if @review.update(review_params)
      redirect_to @product, notice: 'Відгук оновлено!'
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to @product, notice: 'Відгук видалено!'
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def set_review
    @review = Review.find(params[:id])
    @product = @review.product
  end

  def authorize_user!
    redirect_to @product, alert: 'Ви можете редагувати тільки свої відгуки!' unless @review.user == current_user
  end
end