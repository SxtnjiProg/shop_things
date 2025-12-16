class ProductsController < ApplicationController
  # Захищаємо дії, які не є index/show, вимагаючи входу
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  # Pundit: перевіряємо, чи була викликана авторизація
  # ВИПРАВЛЕННЯ: Додано :show до виключень, оскільки це публічна дія.
  after_action :verify_authorized, except: [:index, :show] 
  after_action :verify_policy_scoped, only: [:index]

  def index
    @products = policy_scope(Product)
  end

  def show
    @reviews = @product.reviews.order(created_at: :desc)
    # Тепер тут НЕ потрібен authorize @product
  end

  def new
    @product = Product.new
    authorize @product # Перевіряє ProductPolicy#new?
  end

  def create
    @product = Product.new(product_params)
    authorize @product # Перевіряє ProductPolicy#create?
    
    if @product.save
      redirect_to @product, notice: 'Товар успішно створено.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @product # Перевіряє ProductPolicy#edit?
  end

  def update
    authorize @product # Перевіряє ProductPolicy#update?
    
    if @product.update(product_params)
      redirect_to @product, notice: 'Товар успішно оновлено.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product # Перевіряє ProductPolicy#destroy?
    
    @product.destroy
    redirect_to products_url, notice: 'Товар успішно видалено.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :category, :image, :remote_image_url, :stock)
  end
end