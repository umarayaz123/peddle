class Image < ActiveRecord::Base

  has_attached_file :snap
#  , :styles => {:large => "640x480", :medium => "300x300>", :small => "150x150", :thumb => "100x100>"}
#  validates_presence_of :snap
  belongs_to :product
  belongs_to :product_detail
  belongs_to :store
  belongs_to :user

  validate :file_dimensions, :unless => "errors.any?"

  def file_dimensions
    if is_banner
      unless snap.to_file(:original).blank?
        dimensions = Paperclip::Geometry.from_file(snap.to_file(:original))
        #if dimensions.width != 750 && dimensions.height != 300
        # another check removing temporarily for client
        #if dimensions.width > 100 && dimensions.height > 100
        #  errors.add(:file, 'Please add banner with proper height and width')
        #end
      end
    end
  end

end
