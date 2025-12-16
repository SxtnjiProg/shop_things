class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :reviews, dependent: :destroy  # Користувач може мати відгуки
  def admin?
    self.admin # повертає true або false
  end
end
