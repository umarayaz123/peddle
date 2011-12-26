class AddProfileImageIdAndBgImageIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :profile_image_id, :integer
    add_column :images, :bg_image_id, :integer
  end
end
