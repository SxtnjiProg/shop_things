class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy  # Відгуки залежать від товару
end
