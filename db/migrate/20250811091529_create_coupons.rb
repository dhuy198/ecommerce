class CreateCoupons < ActiveRecord::Migration[8.0]
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :discount_percentage
      t.boolean :active

      t.timestamps
    end
  end
end
