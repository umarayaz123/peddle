class AlterFeedForInTableFeed < ActiveRecord::Migration
  def up
    remove_column :feeds, :feed_for
    add_column :feeds, :feed_for, :string
  end

  def down
    add_column :feeds, :feed_for, :integer
    remove_column :feeds, :feed_for
  end
end
