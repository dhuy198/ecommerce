class Admin::CouponsController < Admin::ApplicationController
    before_action :authenticate_admin!
    before_action :set_coupon, only: [:show, :edit, :update, :destroy]
    def index 
        @coupons = Coupon.all
    end
    def show
    end

    def new
        @coupon = Coupon.new
    end

    def create
        @coupon = Coupon.new(coupon_params)
        if @coupon.save
            redirect_to admin_coupon_path(@coupon), notice: "coupon created successfully."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @coupon.update(coupon_params)
            redirect_to admin_coupon_path(@coupon), notice: "coupon updated successfully."   
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @coupon.destroy
        redirect_to admin_coupons_path, notice: "coupon deleted successfully."
    end

    private

    def set_coupon
        @coupon = Coupon.find(params[:id])
    end

    def coupon_params
        params.require(:coupon).permit(:code, :discount_percentage, :active)
    end
end