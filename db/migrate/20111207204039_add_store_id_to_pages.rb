class AddStoreIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :store_id, :integer
  end
end
