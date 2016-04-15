class Review < ActiveRecord::Base
  paginates_per 6
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

  def count_votes
    votes = Vote.where(review_id: id)
    self.total_votes = votes.inject(0) { |a, vote| a + vote.vote }
    save
    total_votes
  end
end
