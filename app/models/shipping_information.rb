class ShippingInformation < ApplicationRecord
  belongs_to :user

  validates :full_name, :phone_number, :address, :city, :district, :postal_code, :country, presence: true
end
