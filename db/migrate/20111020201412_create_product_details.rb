class CreateProductDetails < ActiveRecord::Migration
  def change
    create_table :product_details do |t|
      t.integer :product_id
      t.string :size
      t.string :color
      t.float :price

      t.timestamps
    end
  end
end
