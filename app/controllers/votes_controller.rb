class VotesController < ApplicationController
  def create
    @user = current_user
    @review = Review.find(params[:review_id])
    @elevator = @review.elevator

    if @review.user == @user
      flash[:error] = "You cannot vote on your own reviews"
      json_response = { status: '401', error: flash[:error] }
    else
      @vote = Vote.new(user: @user, review: @review, vote: params[:vote])
      unless @vote.save
        @vote = Vote.find_by(user: @user, review: @review)
        if @vote.vote == params['vote'].to_i
          @vote.delete
        else
          @vote.vote = params['vote'].to_i
          @vote.save
        end
      end
      json_response = { status: '200', votes: @review.total_votes }
    end

    respond_to do |format|
      format.json do
        flash.discard(:error)
        render json: json_response
      end
      format.html { redirect_to elevator_path(@elevator) }
    end
  end
end
