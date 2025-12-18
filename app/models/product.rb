# app/models/product.rb

class Product < ApplicationRecord
  belongs_to :category
  # Встановлює зв'язок 1:багато з Review
  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  
  # Асоціації для завантаження зображень (використовується ImageUploader)
  mount_uploader :image, ImageUploader
  mount_uploader :image_2, ImageUploader # НОВЕ
  mount_uploader :image_3, ImageUploader # НОВЕ
  mount_uploader :image_4, ImageUploader # НОВЕ

  # Валідації (якщо вони є)
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end