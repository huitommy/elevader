class SessionsController < ApplicationController
  def show
    response = {
      user_id: current_user.id
    }.to_json
    render json: response
  end
end