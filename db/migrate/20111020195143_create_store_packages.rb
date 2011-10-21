class CreateStorePackages < ActiveRecord::Migration
  def c
    hange
    create_table :store_packages do |t|
      t.integer :package_id
      t.integer :store_id

      t.timestamps
    end
  end
end
