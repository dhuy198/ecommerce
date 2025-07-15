class WishlistsController < ApplicationController
  before_action :authenticate_user!
  def show
    @wishlist = current_user.wishlist
    @wishlist_items = @wishlist.wishlist_items.includes(:product)
  end
end
