class ReviewsController < PermissionsController
  before_filter :require_permission, only: [:edit, :destroy]

  def create
    @elevator = Elevator.find(params[:elevator_id])
    @review = current_user.reviews.build(review_params)
    @rating = Review::RATING
    @reviews = @elevator.reviews

    @review.elevator = @elevator
    if @review.save
      flash[:notice] = 'Review Added!'
      redirect_to elevator_path(@elevator)
    else
      flash[:notice] = @review.errors.full_messages.join(', ')
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
    if params[:vote].nil?
      if @review.update(review_params)
        flash[:notice] = 'Review was updated successfully'
        redirect_to elevator_path(@review.elevator)
      else
        flash[:alert] = @review.errors.full_messages.join('. ')
        render :edit
      end
    else
      if current_user == @review.user
        flash[:error] = "You cannot vote on your own reviews"
        redirect_to elevator_path(@review.elevator)
      else
        current_vote = params[:vote].to_i
        previous_vote = Vote.find_by(user: current_user, review: @review)
        if previous_vote.nil?
          Vote.create(user: current_user, review: @review, vote: current_vote)
          @review.total_votes += params[:vote].to_i
        else
          if previous_vote.vote == current_vote
            previous_vote.destroy
            @review.total_votes -= current_vote
          else
            previous_vote.vote = current_vote
            previous_vote.save
            @review.total_votes -= 2 * current_vote
          end
        end
        @review.save
        redirect_to elevator_path(@review.elevator)
      end
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
