class AddColumnToOrder < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :is_cancel, :boolean, default: false
  end
end
