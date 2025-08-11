class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_cart_id, null: false
      t.string :brand
      t.string :last4
      t.integer :exp_month
      t.integer :exp_year

      t.timestamps
    end
  end
end
