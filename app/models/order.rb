class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  validates :gname, :gemail, :gphone, :gaddress, :gcity, :gcountry, presence: true, if: -> {user_id.nil?} 
end
