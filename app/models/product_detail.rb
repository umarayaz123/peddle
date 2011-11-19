class ProductDetail < ActiveRecord::Base

  belongs_to :product
  has_many :images
  accepts_nested_attributes_for :images

  default_scope :order => 'size'
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  private
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end

end
