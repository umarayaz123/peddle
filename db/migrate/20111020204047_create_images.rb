class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :snap_file_name
      t.string :snap_content_type
      t.integer :snap_file_size
      t.datetime :snap_updated_at
      t.integer :attachable_id
      t.string :attachable_type
      t.integer :product_id
      t.integer :product_detail_id

      t.timestamps
    end
  end
end
