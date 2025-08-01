class AddDiscoutToProduct < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :discount_type, :integer
  end
end
