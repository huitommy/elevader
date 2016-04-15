class Elevator < ActiveRecord::Base
  mount_uploader :elevator, ElevatorUploader

  paginates_per 6
  belongs_to :user
  has_many :reviews, dependent: :destroy

  validates :building_name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true, numericality: true, length: { is: 5 }
  validates :state, presence: true
  validates :user_id, presence: true
  validates_integrity_of :elevator
  validates_processing_of :elevator

  fuzzily_searchable :building_name
  Elevator.bulk_update_fuzzy_building_name

  def average_rating
    reviews = Review.where(elevator: self)
    rtg_sum = reviews.inject(0) { |a, review| a + review.rating }
    avg = reviews.empty? ? 0 : rtg_sum.to_f / reviews.length
    avg.round
  end
end
