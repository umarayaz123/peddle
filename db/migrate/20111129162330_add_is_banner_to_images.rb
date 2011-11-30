class AddIsBannerToImages < ActiveRecord::Migration
  def change
    add_column :images, :is_banner, :boolean
  end
end
