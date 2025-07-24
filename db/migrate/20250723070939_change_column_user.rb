class ChangeColumnUser < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :adddress, :address
  end
end
