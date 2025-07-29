class ShippingInformationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @shipping_information = current_user.build_shipping_information(shipping_info_params)
    @cart = current_user.cart
    if @shipping_information.save
      respond_to do |format|
        format.html { redirect_to cart_path }
        format.js   
      end
    else
      respond_to do |format|
        format.html { render 'carts/show' }
        format.js  
      end
    end
  end

  def update
    @shipping_information = current_user.shipping_information
    if @shipping_information.update(shipping_information_params)
      respond_to do |format|
        format.html { redirect_to cart_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'carts/show' }
        format.js
      end
    end
  end

  private

  def shipping_info_params
    params.require(:shipping_information).permit(:full_name, :phone_number, :address, :city, :district, :postal_code, :country)
  end
end
