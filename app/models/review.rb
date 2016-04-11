class Review < ActiveRecord::Base
  belongs_to :elevator
  belongs_to :user
  has_many :votes, dependent: :destroy

  RATING = [
    [1, "1"],
    [2, "2"],
    [3, "3"],
    [4, "4"],
    [5, "5"]
  ]

  validates :user_id, presence: true
  validates :elevator_id, presence: true
  validates :rating, presence: true
  validates :total_votes, presence: true
end
