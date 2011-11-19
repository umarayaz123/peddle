class LineItem < ActiveRecord::Base

  belongs_to :product_detail
  belongs_to :cart

  def total_price
    product_detail.price
  end


end
