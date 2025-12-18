class CategoryPolicy < ApplicationPolicy
  # Дозволяємо переглядати всім (якщо використовуєте index/show)
  def index?
    true
  end

  def show?
    true
  end

  # Створення та редагування — тільки для адміна
  def create?
    user.present? && user.admin?
  end

  def new?
    create?
  end

  def update?
    user.present? && user.admin?
  end

  def edit?
    update?
  end

  # Видалення — тільки для адміна
  def destroy?
    user.present? && user.admin?
  end
end