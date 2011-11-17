class Store < ActiveRecord::Base

  has_many :products
  belongs_to :package
  has_many :users
  has_one :image
  accepts_nested_attributes_for :image

end
