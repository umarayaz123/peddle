class User < ActiveRecord::Base
  has_many :orders
  has_one :profile_image, :class_name => "Image", :foreign_key => :profile_image_id
  accepts_nested_attributes_for :profile_image
  has_one :bg_image, :class_name => "Image", :foreign_key => :bg_image_id
  accepts_nested_attributes_for :bg_image
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  has_and_belongs_to_many :roles
  belongs_to :store

end
