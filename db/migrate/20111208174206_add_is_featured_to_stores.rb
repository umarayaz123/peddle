class AddIsFeaturedToStores < ActiveRecord::Migration
  def change
    add_column :stores, :is_featured, :boolean
  end
end
