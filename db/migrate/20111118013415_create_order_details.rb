class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details do |t|
      t.integer :product_detail_id
      t.integer :order_id

      t.timestamps
    end
  end
end
