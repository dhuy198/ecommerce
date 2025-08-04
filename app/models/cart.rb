class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :user_id, presence: true

  def total
    self.cart_items.includes(:product).sum do |item|
      item.quantity * item.product.price
    end
  end 
end
