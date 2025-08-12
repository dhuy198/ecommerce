class Api::V1::CouponsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def apply
    code = params[:code].to_s.strip.upcase
    coupon = Coupon.find_by(code: code, active: true)

    if coupon
      cart_total = current_user.cart.total
      discounted_total = cart_total * (1 - coupon.discount_percentage / 100.0)
      cart_total = discounted_total

      render json: {
        success: true,
        coupon: coupon.code,
        discount_percentage: coupon.discount_percentage,        
        cart_total: cart_total
      }
    else
      render json: { success: false, message: "Coupon do not exist" }, status: :not_found
    end
  end
end
