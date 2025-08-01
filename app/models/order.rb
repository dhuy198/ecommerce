class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items
  validates :gname, :gemail, :gphone, :gaddress, :gcity, :gcountry, presence: true, if: -> {user_id.nil?} 
  accepts_nested_attributes_for :order_items, allow_destroy: true
end
