class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_product, only: [:new, :create]

  def index
    @reviews = Review.includes(:user, :product).recent
  end

  def show
  end

  def new
    @review = @product.reviews.build
  end

  def edit
    @product = Product.find(params[:product_id])
    @review = @product.reviews.find(params[:id])
    render partial: "reviews/edit_form", locals: { review: @review, product: @product }
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: 'Review was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @product = Product.find(params[:product_id])
    @review = @product.reviews.find(params[:id])
    if @review.update(review_params)
      # Render lại partial review (không phải form) để turbo-frame update
      render partial: "reviews/review", locals: { review: @review, product: @product }
    else
      render partial: "reviews/edit_form", locals: { review: @review, product: @product }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_review_owner
    
    product = @review.product
    @review.destroy
    redirect_to product, notice: 'Review was successfully deleted.'
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def review_params
    params.require(:review).permit(:star, :comment)
  end

  def authorize_review_owner
    unless @review.user == current_user
      redirect_to @review.product, alert: 'You can only edit your own reviews.'
    end
  end
end
