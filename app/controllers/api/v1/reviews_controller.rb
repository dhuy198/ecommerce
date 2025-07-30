class Api::V1::ReviewsController < ApplicationController
    before_action :set_product
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    def create
        review = @product.reviews.build(review_params.merge(user: current_user))
        if review.save
            render json: review, status: :created
        else
            render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def set_product
        @product = Product.find(params[:product_id])
    end

    def review_params
        params.require(:review).permit(:comment, :star)
    end
end
