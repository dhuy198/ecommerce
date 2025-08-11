class AddColumnToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :ex_price, :decimal
  end
end
