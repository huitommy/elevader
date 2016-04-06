class Elevator < ActiveRecord::Base
  belongs_to :user
  has_many :reviews

  validates :building_name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true, numericality: true, length: { is: 5 }
  validates :state, presence: true
end
