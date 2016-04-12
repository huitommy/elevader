class VotesController < ApplicationController
  def create
    user = current_user
    review = Review.find(params['review_id'])
    elevator = review.elevator
    if review.user == user
      flash[:error] = "You cannot vote on your own reviews"
    else
      vote = Vote.new(user: user, review: review, vote: params['vote'])
      unless vote.save
        vote = Vote.find_by(user: user, review: review)
        if vote.vote == params['vote'].to_i
          vote.delete
        else
          vote.vote = params['vote'].to_i
          vote.save
        end
      end
    end
    redirect_to elevator_path(elevator)
  end
end