class CreateTaxes < ActiveRecord::Migration[8.0]
  def change
    create_table :taxes do |t|
      t.datetime :begin
      t.datetime :end
      t.string :name
      t.decimal :value, default: 0

      t.timestamps
    end
  end
end
