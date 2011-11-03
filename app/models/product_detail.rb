class ProductDetail < ActiveRecord::Base

  belongs_to :product
  has_many :images
  accepts_nested_attributes_for :images

end
