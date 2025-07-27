class Api::V1::CartItemsController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    
    def create
        cart_item = CartItem.find_by(cart_id: params[:cart_id], product_id: params[:product_id])
        if cart_item
            cart_item.increment!(:quantity, params[:quantity].to_i)
        else
            cart_item = CartItem.create!(cart_id: params[:cart_id], product_id: params[:product_id], quantity: params[:quantity])
        end
        total_product_id = CartItem.where(cart_id: params[:cart_id]).distinct.count(:product_id)

        render json: {cart_item: cart_item,total_product_id: total_product_id}, status: :created
    end


    def destroy
        cart_item = current_user.cart.cart_items.find_by(id: params[:id])
        if cart_item.present?
            cart_item.destroy
            render json: { status: "destroyed" }, status: :ok
        else
            render json: { error: "Not found" }, status: :not_found
        end
    end

    private

    def cart_items_params
        params.require(:cart_item).permit(:cart_id, :product_id, :quantity)
    end
end
