class ShippingInformationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @shipping_information = current_user.build_shipping_information(shipping_info_params)
    if @shipping_information.save
      redirect_to cart_path, notice: "Shipping info added."
    end
  end

  def update
    @shipping_information = current_user.shipping_information
    if @shipping_information.update(shipping_info_params)
      redirect_to cart_path, notice: "Shipping info updated."
    end
  end

  private

  def shipping_info_params
    params.require(:shipping_information).permit(:full_name, :phone_number, :address, :city, :district, :postal_code, :country)
  end
end
