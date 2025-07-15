class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  belongs_to :product

  validates :wishlist_id, presence: true
  validates :product_id, presence: true
  validates :product_id, uniqueness: { scope: :wishlist_id, message: "is already in this wishlist" }
end
