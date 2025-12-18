class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to profile_path, notice: 'Категорію успішно створено!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def check_admin
    redirect_to root_path, alert: "Доступ заборонено" unless current_user.admin?
  end
end