class AddDiscountToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :discount_value, :decimal
    add_column :products, :discount_type, :string
  end
end
