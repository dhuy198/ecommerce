class Admin::TaxesController < Admin::ApplicationController
    before_action :authenticate_admin!
    before_action :set_tax, only: [:show, :edit, :update, :destroy]

    def index
        @taxes = Tax.all
    end

    def show
    end

    def new
        @tax = Tax.new
    end

    def create
        @tax = Tax.new(tax_params)
        if @tax.save
        redirect_to admin_tax_path(@tax), notice: "Tax created successfully."
        else
        render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @tax.update(tax_params)
        redirect_to admin_tax_path(@tax), notice: "Tax updated successfully."   
        else
        render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @tax.destroy
        redirect_to admin_taxes_path, notice: "Tax deleted successfully."
    end

    private

    def set_tax
        @tax = Tax.find(params[:id])
    end

    def tax_params
        params.require(:tax).permit(:begin, :end, :name, :value)
    end
end
