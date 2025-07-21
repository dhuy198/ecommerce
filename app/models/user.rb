class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :wishlist, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews, dependent: :destroy
  
  after_create :create_wishlist, :create_cart

  enum :role, { user: 0, admin: 1 }
  after_initialize :set_default_role, if: :new_record?

  private
  def set_default_role
    self.role ||= :user
  end

  def create_wishlist
    build_wishlist.save!
    build_cart.save!
  end
end
