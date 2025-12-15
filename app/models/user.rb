class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :reviews, dependent: :destroy  # Користувач може мати відгуки
end
class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end