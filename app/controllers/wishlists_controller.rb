class WishlistsController < ApplicationController
  def show
    if user_signed_in?
      @wishlist = current_user.wishlist 
      @wishlist_items = @wishlist.wishlist_items.includes(:product)
    end
  end
end
