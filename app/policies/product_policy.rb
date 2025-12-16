class ProductPolicy
  attr_reader :user, :product

  def initialize(user, product)
    @user = user
    @product = product
  end

  # =======================================================
  # ДОДАТИ ЦЕЙ ВНУТРІШНІЙ КЛАС ДЛЯ ВИРІШЕННЯ ПОМИЛКИ policy_scope
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # За замовчуванням, дозволяємо всім користувачам (включно з гостями) бачити всі товари
      scope.all 
    end
  end
  # =======================================================

  # Усі можуть бачити каталог і деталі
  def index?
    true
  end
  
  def show?
    true
  end
  
  # Створення, редагування, оновлення та видалення лише для адміністраторів
  def create?
    user.admin?
  end

  def new?
    create?
  end

  def update?
    user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end
end