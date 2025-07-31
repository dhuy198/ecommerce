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
        s = user.shipping_information
        order = user.orders.create!(
            total: 0,
            payment_status: "unpaid",
            deliverd_status: "pending",
            payment_method: "COD",
            shipping_address: "#{s.address} #{s.district} #{s.city} #{s.country}",
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
            item.product.update(stock: item.product.stock - item.quantity)
        end
        
        OrderMailer.thank(order).deliver_later
        order.update!(total: total)
        cart.cart_items.destroy_all

        render json: {
            order_id: order.id,
            total: order.total,
            user_id: user.id,
            payment_status: order.payment_status,
            deliverd_status: order.deliverd_status,
            payment_method: order.payment_method,
            address: order.shipping_address

        }, status: :created
    end
end
