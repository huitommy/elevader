class ReviewsController < ApplicationController
  #before_action :authenticate_user!
  def create
    #current_user

    @elevator = Elevator.find(params[:elevator_id])
    @review = Review.new(review_params)
    @rating = Review::RATING
    @reviews = @elevator.reviews

    # if @current_user.nil?
    #   flash[:notice] = 'Please sign in before adding review'
    #   render 'elevators/show'
    # else
      @review.elevator = @elevator
      @review.user_id = 1 #this should be @review.user_id = @current_user.id
      if @review.save
        flash[:notice] = "Review Added!"
        redirect_to elevator_path(@elevator)
      else
        flash[:notice] = @review.errors.full_messages.join(", ")
        render 'elevators/show'
      end
    # end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
