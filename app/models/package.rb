class Package < ActiveRecord::Base

  has_many :package_rules
  has_many :stores

end
