class ShippingInformation < ApplicationRecord
  belongs_to :user
  validates :full_name, :phone_number, :address, :city, :district, :postal_code, :country, presence: true

  def fully?
    full_name.present? &&
    phone_number.present? &&
    address.present? &&
    city.present? &&
    district.present? &&
    postal_code.present? &&
    country.present?
  end
end
