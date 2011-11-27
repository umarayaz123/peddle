class User < ActiveRecord::Base
  has_one :order
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :confirmable,:recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  has_and_belongs_to_many :roles
  belongs_to :store

  has_one :image
  accepts_nested_attributes_for :image

end
