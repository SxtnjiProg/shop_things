class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    
    # Замовлення для звичайного користувача (Тільки свої)
    @orders = @user.orders.order(created_at: :desc)

    if @user.admin?
      @products = Product.all
      # --- ДОДАНО: Завантажуємо ВСІ замовлення для адміна ---
      @admin_orders = Order.includes(:user).order(created_at: :desc)
    end
  end

  def update_info
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Профіль оновлено.'
    else
      @orders = @user.orders.order(created_at: :desc)
      if @user.admin?
        @products = Product.all
        @admin_orders = Order.includes(:user).order(created_at: :desc)
      end
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email) 
  end
end