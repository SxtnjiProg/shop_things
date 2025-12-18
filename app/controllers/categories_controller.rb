class CategoriesController < ApplicationController
  # 1. Дозволяємо переглядати категорії всім (навіть гостям), 
  # але вимагаємо вхід для створення/видалення
  before_action :authenticate_user!, except: [:index, :show]
  
  # 2. Знаходимо категорію перед показом або видаленням
  before_action :set_category, only: [:show, :destroy]

  # 3. Перевіряємо адміна ТІЛЬКИ для дій зміни (створення, видалення)
  # Звичайні користувачі не зможуть зайти на ці сторінки
  before_action :check_admin, only: [:new, :create, :destroy]

  # Список всіх категорій (для сторінки керування)
  def index
    @categories = Category.all
  end

  # Сторінка конкретної категорії (тут можна вивести товари цієї категорії)
  def show
    # Якщо у вас є зв'язок has_many :products
    @products = @category.products
  end

  def new
    @category = Category.new
    @categories = Category.all
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: 'Категорію успішно створено!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Метод видалення (тільки для адміна)
  def destroy
    @category.destroy
    redirect_to categories_path, notice: 'Категорію успішно видалено.'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def check_admin
    # current_user&.admin? перевіряє, чи адмін, не падаючи з помилкою, якщо user nil
    unless current_user&.admin?
      redirect_to root_path, alert: "Доступ заборонено! Тільки для адміністраторів."
    end
  end
end