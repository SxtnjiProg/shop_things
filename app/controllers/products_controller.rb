class ProductsController < ApplicationController
  # Захищаємо дії, вимагаючи входу (крім перегляду)
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # Pundit: перевірки авторизації
  after_action :verify_authorized, except: [:index, :show]
  after_action :verify_policy_scoped, only: [:index]

  def index
    @products = policy_scope(Product)
  end

  def show
    @reviews = @product.reviews.order(created_at: :desc)
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    # Використовуємо наш (налагоджений) метод product_params
    @product = Product.new(product_params)
    authorize @product

    if @product.save
      redirect_to @product, notice: 'Товар успішно створено.'
    else
      # Якщо помилка - виведемо її в консоль для перевірки
      puts "!!! ПОМИЛКА ЗБЕРЕЖЕННЯ: #{@product.errors.full_messages} !!!"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @product
  end

  def update
    authorize @product

    if @product.update(product_params)
      redirect_to @product, notice: 'Товар успішно оновлено.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product
    @product.destroy
    redirect_to products_url, notice: 'Товар успішно видалено.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  # Основний метод, де виникала помилка
  def product_params
    # 1. Виводимо в консоль те, що прийшло
    puts "=== [DEBUG] Вхідні параметри: #{params[:product].inspect} ==="

    permitted = params.require(:product).permit(
      :name,
      :price,
      :description,
      :stock,
      :category_id,       # Важливий параметр
      :image,
      :remote_image_url,
      :image_2,
      :image_3,
      :image_4
    )

    # 2. Виводимо в консоль те, що Rails дозволив
    puts "=== [DEBUG] Дозволені параметри (після permit): #{permitted.inspect} ==="

    permitted
  end
end