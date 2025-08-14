class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]
  def index
    @orders = current_user.orders.order(created_at: :desc) 
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
  cart = JSON.parse(params[:cart] || "[]")
  total = 0
  order_items = []
  stock_errors = []
  p cart
  cart.each do |item|
    product = Product.find_by(id: item["id"])
    quantity = item["quantity"].to_i
    next unless product

    if product.stock < quantity
      stock_errors << "Sản phẩm '#{product.name}' chỉ còn #{product.stock} trong kho."
      next
    end

    order_items << {
      product: product,
      quantity: quantity,
      price: product.price
    }

    total += product.price * quantity
  end

  if stock_errors.any?
    flash[:alert] = stock_errors.join("\n")
    return redirect_to cart_path
  end

  @order = Order.new(order_params)
  @order.total = total
    
  if @order.save
    order_items.each do |item|
      @order.order_items.create!(
        product: item[:product],
        price: item[:price],
        quantity: item[:quantity]
      )
      item[:product].update!(stock: item[:product].stock - item[:quantity])
    end

    OrderMailer.thank(@order).deliver_later
    redirect_to cart_path, notice: "Đặt hàng thành công"
  else
    Rails.logger.info @order.errors.full_messages
    render :new, status: :unprocessable_entity
  end
end



private

def order_params
  params.require(:order).permit(:gname, :gemail, :gphone, :gaddress, :gcity, :gcountry,:payment_status, :payment_method, :deliverd_status)
end


end
