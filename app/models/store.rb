class Store < ActiveRecord::Base

  has_many :products
  belongs_to :package
  has_many :users

end
