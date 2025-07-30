class Admin::OrdersController < Admin::ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :edit, :update]

  def index
    @orders = Order.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to admin_orders_path, notice: "Order updated successfully."
    else
      render :edit
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:total, :payment_status, :payment_method, :deliverd_status, :shipping_address)
  end
end
