class Searches::ProductSearchService
  # khoi tao
  def initialize(params = {})
    @query = params[:query]&.strip&.downcase
    @category_id = params[:category_id]
    @sort = params[:sort]
  end

  def call
    products = Product.includes(:category)

    if @query.present?
      products = products.where("name ILIKE :q OR description ILIKE :q", q: "%#{@query}%")
    end

    if @category_id.present?
      products = products.where(category_id: @category_id)
    end

    if @sort.present?
      products = sort(products)
    end

    products
  end
  private
  def sort(products)
    case @sort
    when "price_asc"
      products.order(price: :asc)
    when "price_desc"
      products.order(price: :desc)
    else
      products
    end
  end
end
