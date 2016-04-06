class ReviewsController < ApplicationController
  def create
    @elevator = Elevator.find(params[:elevator_id])
    @review = Review.new(review_params)
    @rating = Review::RATING
    @reviews = @elevator.reviews
    @review.elevator = @elevator
    @review.user_id = 1
    if @review.save
      flash[:notice] = "Review Added!"
      redirect_to elevator_path(@elevator)
    else
      flash[:notice] = @review.errors.full_messages.join(", ")
      render 'elevators/show'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @elevator = @review.elevator
    @review.delete
    flash[:notice] = "Review was deleted"
    redirect_to @elevator
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
