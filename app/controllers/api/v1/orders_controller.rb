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
      shipping_address: "#{s.address} #{s.district} #{s.city} #{s.country}"
    )

    stock_errors = []
    total = 0

    items = cart.cart_items.includes(:product)

    items.each do |item|
      if item.product.stock < item.quantity
        stock_errors << {
          product_name: item.product.name,
          available_stock: item.product.stock,
          requested_quantity: item.quantity,
          message: "Sản phẩm '#{item.product.name}' chỉ còn #{item.product.stock} cái."
        }
      end
    end

    if stock_errors.any?
      return render json: {
        error: "Một số sản phẩm vượt quá số lượng tồn kho",
        messages: stock_errors.map { |e| e[:message] },
        insufficient_items: stock_errors
      }, status: :unprocessable_entity
    end

    items.each do |item|
      price = item.product.price
      quantity = item.quantity
      total += price * quantity

      order.order_items.create!(
        product: item.product,
        price: price,
        quantity: quantity
      )

      item.product.update!(stock: item.product.stock - item.quantity)
    end

    order.update!(total: total)
    cart.cart_items.destroy_all
    OrderMailer.thank(order).deliver_later

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
