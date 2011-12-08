class Store < ActiveRecord::Base

  has_many :products
  has_many :pages
  belongs_to :package
  has_many :users
  has_one :image
  accepts_nested_attributes_for :image

  validates_uniqueness_of :name

  def valid_store?
    store = Store.where("name = ?", name)
    if store.blank?
      true
    else
      false
    end
  end

end
