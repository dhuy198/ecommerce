module CategoriesHelper
  def category_image_tag(category, options = {})
    filename = "#{category.name.parameterize}.png"
    path = Rails.root.join("app", "assets", "images", filename)
    image_tag(File.exist?(path) ? filename : "chair.png", options)
  end
end
