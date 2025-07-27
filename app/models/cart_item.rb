class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :cart_id, :product_id, presence: true
  validates :quantity, numericality: { greater_than: 0 }
end
