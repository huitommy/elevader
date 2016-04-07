class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :timeoutable, :rememberable, :trackable, :validatable,
         :database_authenticatable

  validates :password, presence: false
end
