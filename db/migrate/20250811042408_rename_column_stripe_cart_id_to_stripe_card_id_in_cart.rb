class RenameColumnStripeCartIdToStripeCardIdInCart < ActiveRecord::Migration[8.0]
  def change
    rename_column :cards, :stripe_cart_id, :stripe_card_id
  end
end
