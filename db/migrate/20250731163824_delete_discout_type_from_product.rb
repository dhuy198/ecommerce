class DeleteDiscoutTypeFromProduct < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :discount_type, :integer, using: 'discount_type::integer', default: 0
  end
end
