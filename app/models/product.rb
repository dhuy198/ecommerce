class Product < ApplicationRecord
  belongs_to :category

  validates :name, :description, :category_id, presence: true
  validates :price, presence: true, numericality: {
    greater_than: 0
  }
  validates :stock, presence: true, numericality: {
    greater_than_or_equal_to: 0
  }

  has_one_attached :image
end
