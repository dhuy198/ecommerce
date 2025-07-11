class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
