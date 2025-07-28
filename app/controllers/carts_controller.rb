class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_user.cart
    @cart_items = @cart.cart_items.includes(:product)
    @total = 0
    @cart.cart_items.each do |item|
      @total += item.product.price * item.quantity
    end
    @shipping_information = current_user.shipping_information || current_user.build_shipping_information
  end
end
