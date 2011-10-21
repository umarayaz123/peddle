class CreatePackageRules < ActiveRecord::Migration
  def change
    create_table :package_rules do |t|
      t.integer :package_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
