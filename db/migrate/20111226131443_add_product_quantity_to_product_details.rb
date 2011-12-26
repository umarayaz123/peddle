class AddProductQuantityToProductDetails < ActiveRecord::Migration
  def change
    add_column :product_details, :product_quantity, :integer
  end
end
