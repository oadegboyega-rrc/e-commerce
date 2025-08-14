class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :category
      t.boolean :on_sale
      t.boolean :new_arrival

      t.timestamps
    end
  end
end
