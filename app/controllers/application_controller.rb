class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :load_data

  private
  def load_data
    @categories = Category.all
    @products = Product.all
  end
end
