class Admin::ProductsController < Admin::ApplicationController
  before_action :authenticate_admin!
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product), notice: 'Product created successfully.'
    else
      render :new
    end
  end

  def edit
  end

 def update
    if params[:product][:remove_image_ids].present?
      params[:product][:remove_image_ids].each do |image_id|
        @product.images.find(image_id).purge
      end
    end

    if @product.update(product_params.except(:images, :remove_image_ids))
      if params[:product][:images].present?
        @product.images.attach(params[:product][:images])
      end

      redirect_to admin_product_path(@product), notice: 'Product updated successfully.'
    else
      render :edit
    end
  end



  def destroy
    @product.update(is_deleted: true)
    redirect_to admin_products_path, notice: 'Product deleted (soft delete).'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category_id,:ex_price, images: [], remove_image_ids: [])
  end
end
