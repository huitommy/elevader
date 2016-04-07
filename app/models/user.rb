class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  devise :registerable, :recoverable, :rememberable, :trackable, :validatable, :database_authenticatable

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates_presence_of :avatar
  validates_integrity_of :avatar
  validates_processing_of :avatar

  has_many :reviews, dependent: :destroy
  has_many :elevators, dependent: :destroy
end
