class Api::V1::WishlistItemsController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    
    def create
        wishlist_item = WishlistItem.create!(wishlist_items_params)
        render json: wishlist_item, status: :ok
    end


    def destroy
        wishlist_item = current_user.wishlist.wishlist_items.find_by(id: params[:id])
        if wishlist_item.present?
            wishlist_item.destroy
            render json: { status: "destroyed" }, status: :ok
        else
            render json: { error: "Not found" }, status: :not_found
        end
    end

    private

    def wishlist_items_params
        params.require(:wishlist_item).permit(:wishlist_id, :product_id)
    end
end
