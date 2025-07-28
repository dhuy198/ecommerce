class CreateShippingInformations < ActiveRecord::Migration[8.0]
  def change
    create_table :shipping_informations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name
      t.string :phone_number
      t.text :address
      t.string :city
      t.string :district
      t.string :postal_code
      t.string :country

      t.timestamps
    end
  end
end
