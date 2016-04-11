class Vote < ActiveRecord::Base
  belongs_to :review
  belongs_to :user
  validates :user, uniqueness: { scope: :review }
  validates :vote, inclusion: { in: [-1, 1] }

  def self.voted?(user, review)
    votes = Vote.where(
      user: user,
      review: review
    )
    votes.empty?
  end
end