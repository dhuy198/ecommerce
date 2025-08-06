class OrdersController < ApplicationController
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
    @order = Order.new(order_params)

    if @order.save
        cart_items = JSON.parse(params[:cart_items] || "[]")
        total = 0

        cart_items.each do |item|
        product = Product.find_by(id: item["id"])
        next unless product

        quantity = item["quantity"].to_i
        total += product.price * quantity

        @order.order_items.create!(
            product: product,
            price: product.price,
            quantity: quantity
        )

        product.update!(stock: product.stock - quantity)
        end

        @order.update!(total: total)
        OrderMailer.thank(@order).deliver_later
        redirect_to cart_path, notice: "Order placed successfully"
    else
        render :new, status: :unprocessable_entity
    end
    end

private

def order_params
  params.require(:order).permit(:gname, :gemail, :gphone, :gaddress, :gcity, :gcountry)
end


end
