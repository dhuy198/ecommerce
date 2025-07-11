class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :stock
      t.references :category, null: false, foreign_key: true
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
