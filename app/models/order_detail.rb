class OrderDetail < ActiveRecord::Base

  belongs_to :product_detail
  belongs_to :order

  def total_price
    product_detail.price
  end


end
