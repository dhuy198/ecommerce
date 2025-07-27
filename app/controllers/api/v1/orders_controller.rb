class Api::V1::OrdersController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    def create
        user = User.find_by(id: params[:user_id])

        unless user
        return render json: { error: "User not found" }, status: :not_found
        end

        cart = user.cart
        if cart.cart_items.empty?
        return render json: { error: "Empty order" }, status: :unprocessable_entity
        end

        order = user.orders.create!(
        total: 0,
        status: "pending"
        )

        total = 0
        cart.cart_items.includes(:product).each do |item|
        price = item.product.price
        quantity = item.quantity
        total += price * quantity

        order.order_items.create!(
            product: item.product,
            price: price,
            quantity: quantity
        )
        end

        order.update!(total: total)
        cart.cart_items.destroy_all

        render json: {
        order_id: order.id,
        total: order.total,
        email: user.email,
        address: user.address
        }, status: :created
    end
end
