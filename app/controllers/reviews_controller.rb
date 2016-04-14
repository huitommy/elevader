require 'rest-client'

class ReviewsController < PermissionsController
  before_filter :require_permission, only: [:edit, :destroy]

  def create
    @elevator = Elevator.find(params[:elevator_id])
    @review = current_user.reviews.build(review_params)
    @rating = Review::RATING
    @reviews = @elevator.reviews
    @user = @elevator.user

    @review.elevator = @elevator
    if @review.save

      UserMailer.added_review(@user, @elevator).deliver
      flash[:notice] = 'Review Added!'
      redirect_to elevator_path(@elevator)
    else
      flash[:error] = @review.errors.full_messages.join(', ')
      render 'elevators/show'
    end
  end

  def edit
    @review = Review.find(params[:id])
    @elevator = @review.elevator
    @rating = Review::RATING
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      flash[:notice] = 'Review was updated successfully'
      redirect_to elevator_path(@review.elevator)
    else
      flash[:error] = @review.errors.full_messages.join('. ')
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @elevator = @review.elevator
    @review.destroy
    flash[:notice] = "Review was deleted"
    redirect_to @elevator
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body, :vote)
  end
end
