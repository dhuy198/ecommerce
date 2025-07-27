class AddColumnChosedToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_column :cart_items, :selected, :boolean, default: false
  end
end
