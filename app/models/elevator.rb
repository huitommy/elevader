class Elevator < ActiveRecord::Base
  mount_uploader :elevator, ElevatorUploader

  paginates_per 9
  belongs_to :user
  has_many :reviews

  validates :building_name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true, numericality: true, length: { is: 5 }
  validates :state, presence: true
  validates :user_id, presence: true

  validates_integrity_of :elevator
  validates_processing_of :elevator
end
