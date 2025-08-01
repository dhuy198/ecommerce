class Admin::OrdersController < Admin::ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :edit, :update]

  def index
    @orders = Order.includes(:user).order(created_at: :desc)
  end

  def show
  end
  def new 
    @order = Order.new
    @order.order_items.build  
  end
  def edit
  end
  def create 
    @order = Order.new(order_params)
    if (@order.save) 
      redirect_to admin_orders_path
    else
      render :new
    end
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
    params.require(:order).permit(:total, :payment_status, :payment_method, :deliverd_status, :shipping_address, :gname, :gemail, :gphone, :gaddress, :gcity, :gcountry,
      order_items_attributes: [:product_id, :quantity])
  end
end
