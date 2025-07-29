class Api::V1::ShippingInformationsController < ApplicationController
    before_action :authenticate_user!
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    def create
        @shipping_information = current_user.build_shipping_information(shipping_info_params)
        if @shipping_information.save
          render json: {
            shipping_information: @shipping_information
          }, status: :created
        else
          render json: {
            errors: @shipping_information.errors.full_messages
          }, status: :unprocessable_entity
        end
    end

    def update
        @shipping_information = current_user.shipping_information
        if @shipping_information.update(shipping_info_params)
          render json: {
            shipping_information: @shipping_information
          }, status: :ok
        else
          render json: {
            errors: @shipping_information.errors.full_messages
          }, status: :unprocessable_entity
        end
    end

    private
    def shipping_info_params
        params.require(:shipping_information).permit(:full_name, :phone_number, :address, :city, :district, :postal_code, :country)
    end
end