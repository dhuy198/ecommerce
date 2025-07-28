class AddColumnToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :deliverd_status, :string
    add_column :orders, :payment_method, :string
    add_column :orders, :shipping_address, :string
  end
end
