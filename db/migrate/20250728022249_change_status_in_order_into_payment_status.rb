class ChangeStatusInOrderIntoPaymentStatus < ActiveRecord::Migration[8.0]
  def change
    rename_column :orders, :status, :payment_status
  end
end
