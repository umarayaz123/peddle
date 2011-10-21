class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.integer :package_id
      t.string :name
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
