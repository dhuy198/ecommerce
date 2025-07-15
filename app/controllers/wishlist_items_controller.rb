class WishlistItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @wishlist = current_user.wishlist
    # Check if product is already in wishlist
    if @wishlist.products.include?(Product.find(params[:product_id]))
      redirect_back(fallback_location: root_path, alert: "Product is already in your wishlist")
      return
    end

    @wishlist_item = @wishlist.wishlist_items.new(product_id: params[:product_id])

    if @wishlist_item.save
      redirect_back(fallback_location: root_path, notice: "Product added to wishlist")
    else
      redirect_back(fallback_location: root_path, alert: "Failed to add product to wishlist")
    end
  end

  def destroy
    @wishlist = current_user.wishlist

    unless @wishlist
      redirect_back(fallback_location: root_path, alert: "Wishlist not found")
      return
    end

    @wishlist_item = @wishlist.wishlist_items.find(params[:id])

    if @wishlist_item.present?
      if @wishlist_item.destroy
        redirect_back(fallback_location: root_path, notice: "Product removed from wishlist")
      else
        redirect_back(fallback_location: root_path, alert: "Failed to remove product from wishlist")
      end
    else
      redirect_back(fallback_location: root_path, alert: "Item not found in wishlist")
    end
  end
end
