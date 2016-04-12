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

  def total_votes
    votes = Vote.where(review_id: id)
    result = votes.inject(0) { |a, vote| a + vote.vote }
  end
end
