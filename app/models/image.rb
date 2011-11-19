class Image < ActiveRecord::Base

  has_attached_file :snap
#  , :styles => {:large => "640x480", :medium => "300x300>", :small => "150x150", :thumb => "100x100>"}
#  validates_presence_of :snap
  belongs_to :product
  belongs_to :product_detail
  belongs_to :store
  belongs_to :user
end
