class Product < ApplicationRecord
  belongs_to :category
  has_many :wishlist_items, dependent: :destroy
  has_many :wishlists, through: :wishlist_items
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items

  validates :name, :description, :category_id, presence: true
  validates :price, presence: true, numericality: {
    greater_than: 0
  }
  validates :stock, presence: true, numericality: {
    greater_than_or_equal_to: 0
  }

  has_one_attached :image
end
