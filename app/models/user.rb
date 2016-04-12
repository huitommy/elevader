class User < ActiveRecord::Base
  paginates_per 10
  devise :registerable, :recoverable, :rememberable, :trackable, :validatable, :database_authenticatable

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  has_many :reviews, dependent: :destroy
  has_many :elevators, dependent: :destroy
  has_many :votes, dependent: :destroy
end
