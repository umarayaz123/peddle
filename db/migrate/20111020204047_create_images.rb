class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.integer :attachable_id
      t.string :attachable_type

      t.timestamps
    end
  end
end
