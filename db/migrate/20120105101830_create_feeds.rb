class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.text :message
      t.integer :user_id
      t.integer :store_id
      t.integer :feed_for

      t.timestamps
    end
  end
end
