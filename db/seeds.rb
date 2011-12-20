# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

puts " ==============================================================================="

puts " Destroying All Packages"
packages = Package.all
packages.each{|package| package.destroy} unless packages.blank?

puts " Destroying All PackageRules"
package_rules = PackageRule.all
package_rules.each{|package_rule| package_rule.destroy} unless package_rules.blank?

puts "Creating default packages:"
puts " ->Creating Start-up package ...."
package = Package.new(:name => "Start-up", :price => "0")

puts "  -> Creating Package Rules for Start-up"
package_rule = PackageRule.create!(:key => "allowed_products", :value => "5" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "allowed_staff_members", :value => "1" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "allowed_images", :value => "1" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "chat", :value => "yes" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "inventory_tracking", :value => "No" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "discount_count", :value => "No" )
package.package_rules << package_rule
package.save!

puts " ->Creating Time to Grow package ...."
package = Package.new(:name => "Time to Grow", :price => "10")

puts "  -> Creating Package Rules for Time to Grow"
package_rule = PackageRule.create!(:key => "allowed_products", :value => "25" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "allowed_staff_members", :value => "3" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "allowed_images", :value => "3" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "chat", :value => "yes" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "inventory_tracking", :value => "yes" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "discount_count", :value => "No" )
package.package_rules << package_rule
package.save!


puts " ->Creating Corporation package ...."
package = Package.new(:name => "Corporation", :price => "20")

puts "  -> Creating Package Rules for Corporation"
package_rule = PackageRule.create!(:key => "allowed_products", :value => "150" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "allowed_staff_members", :value => "10" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "allowed_images", :value => "5" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "chat", :value => "yes" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "inventory_tracking", :value => "yes" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "discount_count", :value => "yes" )
package.package_rules << package_rule
package.save!

puts " ->Creating Enterprise package ...."
package = Package.new(:name => "Enterprise", :price => "175")

puts "  -> Creating Package Rules for Enterprise"
package_rule = PackageRule.create!(:key => "allowed_products", :value => "unlimited" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "allowed_staff_members", :value => "unlimited" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "allowed_images", :value => "5" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "chat", :value => "yes" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "inventory_tracking", :value => "yes" )
package.package_rules << package_rule
package_rule = PackageRule.create!(:key => "discount_count", :value => "yes" )
package.package_rules << package_rule
package.save!

puts " ==============================================================================="


puts "Destroying All Default Roles..."
roles = Role.all
roles.each{ |role| role.destroy } unless roles.blank?

puts "Creating Default Roles..."
super_admin = Role.create!(:name=>'SuperAdmin')
admin_role = Role.create!(:name=>'Admin')
seller = Role.create!(:name=>'Seller')
buyer = Role.create!(:name=>'Buyer')

puts " Destroying All Stores"
stores = Store.all
stores.each{|store| store.destroy} unless stores.blank?

#puts "Creating Admin Store"
#admin_store = Store.create!(:package_id => 1, :name => "adminstore", :description => 'This is admin Store for testing purposes', :url => 'adminstore.peddle.com')
#admin_store.save!
#
#puts "Creating Buyer Store"
#buyer_store = Store.create!(:package_id => 1, :name => "buyerstore", :description => 'This is buyer Store for testing purposes', :url => 'buyerstore.peddle.com')
#buyer_store.save!
#

puts "Destroying All Default Users..."
users = User.all
users.each{ |user| user.destroy } unless users.blank?

puts "Creating Super Admin of Site"
sadmin = User.create!(:email=>'sadmin@peddle.com',:password=>'123456',:password_confirmation => '123456')
#sadmin.store_id = super_admin.id
sadmin.roles << super_admin
sadmin.confirmed_at =Time.now
sadmin.save!

#puts "Creating Admin of Site"
#admin = User.create!(:email=>'admin@peddle.com',:password=>'123456',:password_confirmation => '123456')
#admin.store_id = admin_store.id
#admin.roles << admin_role
#admin.confirmed_at =Time.now
#admin.save!
#
#puts "Creating default Buyer of Site"
#buyer_user = User.create!(:email=>'buyer@peddle.com',:password=>'123456',:password_confirmation => '123456')
#buyer_user.store_id = buyer_store.id
#buyer_user.roles << buyer
#buyer_user.confirmed_at =Time.now
#buyer_user.save!

puts " Destroying All Products"
products = Product.all
products.each{|product| product.destroy} unless products.blank?

puts " Destroying All Images"
imagess = Image.all
imagess.each{|images| images.destroy} unless imagess.blank?

