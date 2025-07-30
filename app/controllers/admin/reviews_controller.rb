class Admin::ReviewsController < Admin::ApplicationController
  before_action :authenticate_admin!

  def index
    @reviews = Review.includes(:user, :product).order(created_at: :desc)
  end
end
