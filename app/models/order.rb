class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # ✅ ВАЖЛИВО: додали paid
  STATUSES = %w[pending paid shipped completed cancelled]

  validates :status, inclusion: { in: STATUSES }
  validates :street, :city, :country, :zip_code, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
end
