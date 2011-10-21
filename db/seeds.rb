# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

puts "Destroying All Default Roles..."
roles = Role.all
roles.each{ |role| role.destroy } unless roles.blank?

puts "Creating Default Roles..."
admin_role = Role.create!(:name=>'Admin')
member = Role.create!(:name=>'Seller')
member = Role.create!(:name=>'Buyer')


puts "Destroying All Default Users..."
users = User.all
users.each{ |user| user.destroy } unless users.blank?


#puts "Creating Default Administrator..."
#admin = User.new(:email=>'admin@peddle.com',
#  :encrypted_password =>'$2a$10$pNOqdqvzymfXS6haNzz6s..nK/uqCw5tXOeYdrpB/Dm3quhXvFiAO'
#)
#
#admin.roles << admin_role
#admin.save!

puts " Destroying All Stores"
stores = Store.all
stores.each{|store| store.destroy} if stores.blank?

puts " Destroying All Packages"
packages = Package.all
packages.each{|package| package.destroy} if packages.blank?

puts " Destroying All Products"
products = Product.all
products.each{|product| product.destroy} if products.blank?

puts " Destroying All Images"
imagess = Image.all
imagess.each{|images| images.destroy} if imagess.blank?
