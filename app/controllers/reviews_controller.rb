require 'rest-client'

class ReviewsController < PermissionsController
  before_filter :require_permission, only: [:edit, :destroy]

  def create
    @elevator = Elevator.find(params[:elevator_id])
    @review = current_user.reviews.build(review_params)
    @rating = Review::RATING
    @reviews = @elevator.reviews
    a = @elevator.user
    @user = a

    @review.elevator = @elevator
    if @review.save

      UserMailer.added_review(@user, @elevator).deliver
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
    if @review.update(review_params)
      flash[:notice] = 'Review was updated successfully'
      redirect_to elevator_path(@review.elevator)
    else
      flash[:alert] = @review.errors.full_messages.join('. ')
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
    params.require(:review).permit(:rating, :body)
  end
  def added_review
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}"\
    "@api.mailgun.net/v3/#{ENV['MAILGUN_DOMAIN']}",
    from: "Excited User #{ENV['MAILGUN_DOMAIN']}",
    to: "bar@example.com, #{ENV['MAILGUN_USER']}",
    subject: "Hello",
    text: "Testing some Mailgun awesomness!"
  end
end
