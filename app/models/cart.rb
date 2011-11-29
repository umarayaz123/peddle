class Cart < ActiveRecord::Base
  has_many :order_details, :dependent => :destroy
  has_one :order

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def total_items
    i = 0
    line_items.each do
      i+=1
    end
    i
  end

end
