class Product < ActiveRecord::Base

  belongs_to :store
  has_one :product_detail

end
