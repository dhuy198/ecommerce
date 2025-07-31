class AddMoreColumnToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :gname, :string
    add_column :orders, :gemail, :string
    add_column :orders, :gphone, :string
    add_column :orders, :gaddress, :string
    add_column :orders, :gcity, :string
    add_column :orders, :gcountry, :string
  end
end
