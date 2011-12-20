require 'iconv'
class Image < ActiveRecord::Base

  has_attached_file :snap
#  , :styles => {:large => "640x480", :medium => "300x300>", :small => "150x150", :thumb => "100x100>"}
#  validates_presence_of :snap
  belongs_to :product
  belongs_to :product_detail
  belongs_to :store
  belongs_to :user

  validate :file_dimensions, :unless => "errors.any?"

  before_post_process :transliterate_file_name

  def file_dimensions
    if is_banner
      #unless snap.to_file(:original).blank?
      dimensions = Paperclip::Geometry.from_file(snap.to_file(:original))
      #if dimensions.width != 750 && dimensions.height != 300
      # another check removing temporarily for client
      #if dimensions.width > 100 && dimensions.height > 100
      #  errors.add(:file, 'Please add banner with proper height and width')
      #end
      #end
    end
  end

  def transliterate(str)
    # Based on permalink_fu by Rick Olsen

    # Escape str by transliterating to UTF-8 with Iconv
    s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s

    # Downcase string
    s.downcase!

    # Remove apostrophes so isn't changes to isnt
    s.gsub!(/'/, '')

    # Replace any non-letter or non-number character with a space
    s.gsub!(/[^A-Za-z0-9]+/, ' ')

    # Remove spaces from beginning and end of string
    s.strip!

    # Replace groups of spaces with single hyphen
    s.gsub!(/\ +/, '-')

    return s
  end

  private

  def transliterate_file_name
    extension = File.extname(snap_file_name).gsub(/^\.+/, '')
    filename  = snap_file_name.gsub(/\.#{extension}$/, '')
    self.snap.instance_write(:file_name, "#{transliterate(filename)}.#{transliterate(extension)}")
  end


end
