class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    cart = current_user.cart
    product = Product.find(params[:product_id])
    cart_item = cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity ||= 0
    cart_item.quantity += params[:quantity].to_i
    if cart_item.save
      redirect_to products_path, notice: "Added to cart!"
    else
      redirect_to products_path, alert: "Failed to add to cart"
    end
  end



  def increase
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.update!(quantity: cart_item.quantity + 1)
    redirect_to cart_path, notice: "Cart updated"
  end

  def decrease
    cart_item = current_user.cart.cart_items.find(params[:id])
    if cart_item.quantity > 1
      cart_item.update!(quantity: cart_item.quantity - 1)
    else
      cart_item.destroy
    end
    redirect_to cart_path, notice: "Cart updated"
  end

  def destroy
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Item removed from cart"
  end
end
