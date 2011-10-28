class Product < ActiveRecord::Base

  belongs_to :store
  has_many :product_details
  has_many :images
  accepts_nested_attributes_for :images

end